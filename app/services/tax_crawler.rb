require 'nokogiri'
require 'httparty'

class TaxCrawler
  include HTTParty
  base_uri 'https://www.irs.gov'
  
  def initialize
    @news_api_key = ENV['NEWS_API_KEY']
  end
  
  def crawl
    tax_tips = []
    tax_tips.concat(crawl_irs_publications)
    tax_tips.concat(crawl_news_api)
    
    tax_tips.each do |tip|
      TaxTip.find_or_create_by!(topic: tip[:topic]) do |t|
        t.industry = tip[:industry]
        t.source_url = tip[:source_url]
        t.sentiment = tip[:sentiment] || 'neutral'
      end
    end
  rescue StandardError => e
    Rails.logger.error("Tax crawling failed: #{e.message}")
    []
  end
  
  private
  
  def crawl_irs_publications
    # Simulated IRS data for MVP
    [
      {
        topic: 'Section 179 Deduction',
        industry: 'Small Business',
        source_url: 'https://www.irs.gov/publications/p946',
        sentiment: 'positive'
      },
      {
        topic: 'Energy Credits',
        industry: 'Renewable Energy',
        source_url: 'https://www.irs.gov/credits-deductions',
        sentiment: 'positive'
      },
      {
        topic: 'Short-term Rental Income',
        industry: 'Short-term Rental',
        source_url: 'https://www.irs.gov/businesses/small-businesses-self-employed',
        sentiment: 'neutral'
      }
    ]
  end
  
  def crawl_news_api
    return [] unless @news_api_key
    
    response = HTTParty.get(
      'https://newsapi.org/v2/everything',
      query: {
        q: 'tax deduction OR tax credit',
        language: 'en',
        sortBy: 'publishedAt',
        apiKey: @news_api_key
      }
    )
    
    return [] unless response.success?
    
    response['articles'].first(5).map do |article|
      {
        topic: article['title'].truncate(100),
        industry: determine_industry(article['description']),
        source_url: article['url'],
        sentiment: analyze_sentiment(article['description'])
      }
    end
  rescue StandardError => e
    Rails.logger.error("News API crawling failed: #{e.message}")
    []
  end
  
  def determine_industry(text)
    return 'Small Business' unless text
    
    text = text.downcase
    case text
    when /real estate|property|housing/
      'Real Estate'
    when /stock|trading|investment|market/
      'Stock Trading'
    when /airbnb|rental|lease/
      'Short-term Rental'
    when /solar|renewable|energy|green/
      'Renewable Energy'
    when /self.employed|freelance|contractor/
      'Self-employed'
    else
      'Small Business'
    end
  end
  
  def analyze_sentiment(text)
    return 'neutral' unless text
    
    text = text.downcase
    positive_words = %w[save benefit advantage increase gain]
    negative_words = %w[cost expense penalty fee risk]
    
    positive_count = positive_words.count { |word| text.include?(word) }
    negative_count = negative_words.count { |word| text.include?(word) }
    
    if positive_count > negative_count
      'positive'
    elsif negative_count > positive_count
      'negative'
    else
      'neutral'
    end
  end
end 