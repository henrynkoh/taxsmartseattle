class ScriptGenerator
  def self.generate_script(tax_tip)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    prompt = generate_prompt(tax_tip)
    
    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7
      }
    )

    format_script(response.dig("choices", 0, "message", "content"))
  rescue StandardError => e
    Rails.logger.error("Error generating script: #{e.message}")
    "Error generating script"
  end

  private

  def self.generate_prompt(tax_tip)
    <<~PROMPT
      Create a 60-second YouTube Shorts script about this tax tip:
      
      Topic: #{tax_tip.topic}
      Industry: #{tax_tip.industry}
      Strategy: #{tax_tip.strategy}
      Case Study: #{tax_tip.case_study}

      Requirements:
      1. Write in a conversational, engaging style
      2. Focus on practical, actionable advice
      3. Include a hook in the first 3 seconds
      4. End with a clear call-to-action
      5. Target Korean and Asian business owners in Seattle
      6. Keep sentences short and clear
      7. Include timestamps for each section
      8. Format: [Timestamp] Action/Visual: Description | Script: Spoken text

      Example format:
      [0:00] Action: Close-up of calculator | Script: "Hey Seattle business owners! Want to save thousands on taxes?"
    PROMPT
  end

  def self.format_script(raw_script)
    # Ensure script follows proper format and timing
    sections = raw_script.split("\n").map(&:strip).reject(&:empty?)
    
    # Validate and adjust timestamps if needed
    formatted_sections = sections.map.with_index do |section, index|
      next section if section.match?(/^\[\d{1,2}:\d{2}\]/)
      
      # Add timestamp if missing
      timestamp = sprintf("[%02d:%02d]", index / 2, (index % 2) * 30)
      "#{timestamp} #{section}"
    end

    formatted_sections.join("\n")
  end
end 