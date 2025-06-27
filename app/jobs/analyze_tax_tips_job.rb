class AnalyzeTaxTipsJob < ApplicationJob
  queue_as :default
  
  def perform(tax_tip_id)
    Rails.logger.info "Starting tax tip analysis for tip #{tax_tip_id}"
    
    begin
      tax_tip = TaxTip.find(tax_tip_id)
      
      # Analyze the tax tip
      analysis = TaxAnalyzer.analyze_tip(tax_tip)
      
      # Update the tax tip with analysis results
      tax_tip.update!(
        sentiment: analysis[:sentiment],
        industry: analysis[:industry],
        strategy: analysis[:strategy],
        case_study: analysis[:case_study]
      )
      
      # Queue script generation
      GenerateScriptJob.perform_later(tax_tip.id)
      
      Rails.logger.info "Completed tax tip analysis for tip #{tax_tip_id}"
    rescue StandardError => e
      Rails.logger.error "Error in tax tip analysis job for tip #{tax_tip_id}: #{e.message}"
      raise e
    end
  end
end 