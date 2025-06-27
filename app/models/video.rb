class Video < ApplicationRecord
  belongs_to :tax_tip

  validates :title, presence: true
  validates :script, presence: true
  validates :status, presence: true, inclusion: {
    in: %w[script_ready ready uploaded upload_failed failed],
    message: "%{value} is not a valid status"
  }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :ready_to_upload, -> { where(status: 'ready') }
  scope :uploaded, -> { where(status: 'uploaded') }
  scope :failed, -> { where(status: %w[upload_failed failed]) }

  def uploaded?
    status == 'uploaded'
  end

  def failed?
    %w[upload_failed failed].include?(status)
  end

  def ready?
    status == 'ready'
  end

  def script_ready?
    status == 'script_ready'
  end

  def youtube_url
    "https://www.youtube.com/watch?v=#{youtube_id}" if youtube_id.present?
  end

  def youtube_short_url
    "https://www.youtube.com/shorts/#{youtube_id}" if youtube_id.present?
  end
end
