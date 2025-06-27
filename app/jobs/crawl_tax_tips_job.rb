class CrawlTaxTipsJob < ApplicationJob
  queue_as :default
  
  def perform
    Rails.logger.info "Starting tax tips crawl job"
    
    begin
      # Fetch tax tips
      tips = TaxCrawler.fetch_tax_tips
      
      # Process each tip
      tips.each do |tip_data|
        # Skip if we already have this tip (based on source URL)
        next if TaxTip.exists?(source_url: tip_data[:source_url])
        
        # Create the tax tip
        tax_tip = TaxTip.create!(
          topic: tip_data[:topic],
          source_url: tip_data[:source_url],
          strategy: tip_data[:strategy]
        )
        
        # Queue analysis job
        AnalyzeTaxTipsJob.perform_later(tax_tip.id)
      end
      
      Rails.logger.info "Completed tax tips crawl job. Found #{tips.count} tips"
    rescue StandardError => e
      Rails.logger.error "Error in tax tips crawl job: #{e.message}"
      raise e
    end
  end
end 