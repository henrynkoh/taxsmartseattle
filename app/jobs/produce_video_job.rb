class ProduceVideoJob < ApplicationJob
  queue_as :default
  
  def perform(video_id)
    Rails.logger.info "Starting video production for video #{video_id}"
    
    begin
      video = Video.find(video_id)
      
      # Generate the video
      if VideoProducer.produce_video(video)
        # Queue upload job
        UploadVideoJob.perform_later(video.id)
        Rails.logger.info "Completed video production for video #{video_id}"
      else
        Rails.logger.error "Failed to produce video #{video_id}"
      end
    rescue StandardError => e
      Rails.logger.error "Error in video production job for video #{video_id}: #{e.message}"
      raise e
    end
  end
end 