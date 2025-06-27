class TaxTip < ApplicationRecord
  has_many :videos, dependent: :destroy

  validates :topic, presence: true
  validates :source_url, presence: true, uniqueness: true
  validates :sentiment, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_industry, ->(industry) { where(industry: industry) }
  scope :positive, -> { where('sentiment >= ?', 0.6) }
  scope :neutral, -> { where('sentiment > ? AND sentiment < ?', 0.4, 0.6) }
  scope :negative, -> { where('sentiment <= ?', 0.4) }

  def sentiment_label
    case
    when sentiment.nil?
      'unknown'
    when sentiment >= 0.6
      'positive'
    when sentiment <= 0.4
      'negative'
    else
      'neutral'
    end
  end
end
