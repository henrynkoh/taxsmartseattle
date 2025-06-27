class DashboardController < ApplicationController
  def index
    @tax_tips = TaxTip.includes(:videos).order(created_at: :desc).limit(10)
    @videos = Video.includes(:tax_tip).order(created_at: :desc).limit(10)
    @stats = {
      total_tax_tips: TaxTip.count,
      total_videos: Video.count,
      pending_videos: Video.pending.count,
      uploaded_videos: Video.uploaded.count,
      failed_videos: Video.failed.count
    }
  end
  
  def tax_tips
    @tax_tips = TaxTip.includes(:videos).order(created_at: :desc)
  end
  
  def videos
    @videos = Video.includes(:tax_tip).order(created_at: :desc)
  end
  
  def approve_video
    video = Video.find(params[:id])
    video.update!(status: 'approved')
    ProduceVideoJob.perform_later(video.id)
    redirect_to videos_path, notice: 'Video approved for production'
  end
  
  def retry_video
    video = Video.find(params[:id])
    
    case video.status
    when 'failed'
      if video.youtube_id.present?
        video.update!(status: 'produced')
        UploadVideoJob.perform_later(video.id)
      elsif video.video_path.present?
        video.update!(status: 'approved')
        ProduceVideoJob.perform_later(video.id)
      else
        video.update!(status: 'pending')
        GenerateScriptJob.perform_later(video.tax_tip.id)
      end
    end
    
    redirect_to videos_path, notice: 'Video queued for retry'
  end
  
  def force_crawl
    CrawlTaxTipsJob.perform_later
    redirect_to root_path, notice: 'Tax tips crawl initiated'
  end
end 