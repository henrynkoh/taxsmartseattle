require 'streamio-ffmpeg'
require 'google/cloud/text_to_speech'

class VideoProducer
  def self.produce_video(video)
    # Create necessary directories
    FileUtils.mkdir_p(Rails.root.join('tmp', 'videos', 'audio'))
    FileUtils.mkdir_p(Rails.root.join('tmp', 'videos', 'images'))
    FileUtils.mkdir_p(Rails.root.join('public', 'videos'))

    begin
      # Generate audio from script
      audio_path = generate_audio(video.script)
      
      # Generate images for each section
      image_paths = generate_images(video.script)
      
      # Combine audio and images into video
      final_video_path = create_video(audio_path, image_paths)
      
      # Generate thumbnail
      thumbnail_path = generate_thumbnail(final_video_path)
      
      # Update video record
      video.update!(
        video_path: final_video_path.relative_path_from(Rails.root.join('public')).to_s,
        thumbnail_path: thumbnail_path.relative_path_from(Rails.root.join('public')).to_s,
        status: 'ready'
      )

      true
    rescue StandardError => e
      Rails.logger.error("Video production failed: #{e.message}")
      video.update(status: 'failed')
      false
    ensure
      # Cleanup temporary files
      cleanup_temp_files(audio_path, image_paths)
    end
  end

  private

  def self.generate_audio(script)
    client = Google::Cloud::TextToSpeech.text_to_speech

    # Extract just the spoken text from the script
    spoken_text = script.split("\n").map do |line|
      line.match(/Script: "(.*?)"/)&.captures&.first
    end.compact.join(" ")

    input = { text: spoken_text }
    voice = {
      language_code: "en-US",
      name: "en-US-Neural2-D",
      ssml_gender: "FEMALE"
    }
    audio_config = {
      audio_encoding: "MP3",
      speaking_rate: 1.1,
      pitch: 0.0
    }

    response = client.synthesize_speech(
      input: input,
      voice: voice,
      audio_config: audio_config
    )

    audio_path = Rails.root.join('tmp', 'videos', 'audio', "#{SecureRandom.uuid}.mp3")
    File.binwrite(audio_path, response.audio_content)
    
    audio_path
  end

  def self.generate_images(script)
    script.split("\n").map.with_index do |section, index|
      if action = section.match(/Action: (.*?) \|/)&.captures&.first
        image_path = Rails.root.join('tmp', 'videos', 'images', "#{index}.jpg")
        
        # For now, we're using placeholder images
        # In a real implementation, you might want to use a service like DALL-E
        # or have a library of pre-made images
        create_placeholder_image(image_path, action)
        
        image_path
      end
    end.compact
  end

  def self.create_placeholder_image(path, text)
    # Create a simple image with text using MiniMagick
    MiniMagick::Tool::Convert.new do |convert|
      convert.size "1080x1920"
      convert.gravity "center"
      convert.background "white"
      convert.fill "black"
      convert << "caption:#{text}"
      convert << path
    end
  end

  def self.create_video(audio_path, image_paths)
    output_path = Rails.root.join('public', 'videos', "#{SecureRandom.uuid}.mp4")
    
    # Calculate duration for each image based on audio length
    audio = FFMPEG::Movie.new(audio_path.to_s)
    duration_per_image = audio.duration / image_paths.length
    
    # Create input file for FFMPEG
    File.open("#{audio_path}.txt", "w") do |f|
      image_paths.each do |image_path|
        f.puts "file '#{image_path}'"
        f.puts "duration #{duration_per_image}"
      end
      # Add last image without duration
      f.puts "file '#{image_paths.last}'"
    end

    # Combine images and audio into video
    movie = FFMPEG::Movie.new(audio_path.to_s)
    movie.transcode(
      output_path.to_s,
      %W(
        -f concat
        -safe 0
        -i #{audio_path}.txt
        -i #{audio_path}
        -c:v libx264
        -c:a aac
        -shortest
        -pix_fmt yuv420p
        -r 30
        -s 1080x1920
      )
    )

    output_path
  end

  def self.generate_thumbnail(video_path)
    thumbnail_path = Rails.root.join('public', 'videos', 'thumbnails', "#{SecureRandom.uuid}.jpg")
    FileUtils.mkdir_p(thumbnail_path.dirname)
    
    movie = FFMPEG::Movie.new(video_path.to_s)
    movie.screenshot(
      thumbnail_path.to_s,
      seek_time: 1,
      resolution: '1080x1920'
    )
    
    thumbnail_path
  end

  def self.cleanup_temp_files(audio_path, image_paths)
    FileUtils.rm_f(audio_path) if audio_path
    FileUtils.rm_f("#{audio_path}.txt") if audio_path
    image_paths&.each { |path| FileUtils.rm_f(path) }
  end
end 