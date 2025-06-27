require 'google/apis/youtube_v3'

class YouTubeUploader
  def self.upload_video(video)
    return false unless video.video_path && video.status == 'ready'

    begin
      youtube = setup_youtube_service
      
      metadata = {
        snippet: {
          title: generate_title(video.tax_tip),
          description: generate_description(video.tax_tip),
          tags: generate_tags(video.tax_tip),
          category_id: '22',  # People & Blogs
          default_language: 'en'
        },
        status: {
          privacy_status: 'public',
          self_declared_made_for_kids: false
        }
      }

      video_path = Rails.root.join('public', video.video_path)
      
      youtube_video = youtube.insert_video(
        'snippet,status',
        metadata,
        upload_source: video_path,
        content_type: 'video/mp4'
      )

      video.update!(
        youtube_id: youtube_video.id,
        status: 'uploaded'
      )

      true
    rescue Google::Apis::Error => e
      Rails.logger.error("YouTube upload failed: #{e.message}")
      video.update(status: 'upload_failed')
      false
    end
  end

  private

  def self.setup_youtube_service
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(ENV['GOOGLE_APPLICATION_CREDENTIALS']),
      scope: 'https://www.googleapis.com/auth/youtube.upload'
    )
    youtube
  end

  def self.generate_title(tax_tip)
    "#{tax_tip.topic} - Seattle Tax Tips for #{tax_tip.industry} #shorts"
  end

  def self.generate_description(tax_tip)
    <<~DESCRIPTION
      💼 Seattle Tax Tips for #{tax_tip.industry}
      
      Key Points:
      #{tax_tip.strategy.split("\n").first(3).join("\n")}
      
      Case Study:
      #{tax_tip.case_study}
      
      🔔 Subscribe for more Seattle tax tips!
      
      #SeattleBusiness #TaxTips ##{tax_tip.industry.gsub(/\s+/, '')} #AsianBusiness #KoreanBusiness #SmallBusiness
      
      Disclaimer: This content is for informational purposes only. Please consult with a qualified tax professional for advice specific to your situation.
    DESCRIPTION
  end

  def self.generate_tags(tax_tip)
    [
      'Seattle Tax Tips',
      'Seattle Business',
      'Korean Business',
      'Asian Business',
      tax_tip.industry,
      'Tax Strategy',
      'Tax Advice',
      'Seattle',
      'Small Business',
      'Tax Planning',
      'Business Tips',
      'shorts'
    ]
  end
end 