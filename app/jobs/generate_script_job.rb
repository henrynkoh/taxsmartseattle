class GenerateScriptJob < ApplicationJob
  queue_as :default
  
  def perform(tax_tip_id)
    Rails.logger.info "Starting script generation for tip #{tax_tip_id}"
    
    begin
      tax_tip = TaxTip.find(tax_tip_id)
      
      # Generate the script
      script = ScriptGenerator.generate_script(tax_tip)
      
      # Create a new video with the script
      video = tax_tip.videos.create!(
        title: "#{tax_tip.topic} - Seattle Tax Tips",
        script: script,
        status: 'script_ready'
      )
      
      # Queue video production
      ProduceVideoJob.perform_later(video.id)
      
      Rails.logger.info "Completed script generation for tip #{tax_tip_id}"
    rescue StandardError => e
      Rails.logger.error "Error in script generation job for tip #{tax_tip_id}: #{e.message}"
      raise e
    end
  end
end 