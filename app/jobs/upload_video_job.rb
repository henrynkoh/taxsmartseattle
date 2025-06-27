class UploadVideoJob < ApplicationJob
  queue_as :default
  
  def perform(video_id)
    Rails.logger.info "Starting video upload for video #{video_id}"
    
    begin
      video = Video.find(video_id)
      
      # Upload to YouTube
      if YouTubeUploader.upload_video(video)
        Rails.logger.info "Completed video upload for video #{video_id}"
      else
        Rails.logger.error "Failed to upload video #{video_id}"
      end
    rescue StandardError => e
      Rails.logger.error "Error in video upload job for video #{video_id}: #{e.message}"
      raise e
    end
  end
end 