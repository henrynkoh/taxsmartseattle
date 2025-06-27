class TaxAnalyzer
  INDUSTRIES = [
    'small_business',
    'renewable_energy',
    'short_term_rental',
    'real_estate',
    'stock_trading',
    'self_employed'
  ]

  def self.analyze_tip(tax_tip)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    # Analyze sentiment
    sentiment = analyze_sentiment(tax_tip.topic + " " + tax_tip.strategy)

    # Generate industry-specific strategies
    industry_strategies = generate_industry_strategies(client, tax_tip)

    # Generate case study
    case_study = generate_case_study(client, tax_tip, industry_strategies)

    {
      sentiment: sentiment,
      industry: determine_primary_industry(industry_strategies),
      strategy: industry_strategies.to_json,
      case_study: case_study
    }
  end

  private

  def self.analyze_sentiment(text)
    analyzer = Sentimental.new
    analyzer.load_defaults
    score = analyzer.score(text)
    # Normalize score to 0-1 range
    (score + 1) / 2.0
  end

  def self.generate_industry_strategies(client, tax_tip)
    prompt = "Given this tax update: #{tax_tip.topic}\n#{tax_tip.strategy}\n\n" \
             "Generate specific tax strategies for these industries: #{INDUSTRIES.join(', ')}"

    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue StandardError => e
    Rails.logger.error("Error generating industry strategies: #{e.message}")
    "Error generating strategies"
  end

  def self.generate_case_study(client, tax_tip, strategies)
    prompt = "Create a detailed case study for a Seattle-based business applying these tax strategies:\n" \
             "#{strategies}\n\nBased on this tax update: #{tax_tip.topic}"

    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue StandardError => e
    Rails.logger.error("Error generating case study: #{e.message}")
    "Error generating case study"
  end

  def self.determine_primary_industry(strategies)
    # Simple approach: return the industry with the most mentions
    INDUSTRIES.max_by do |industry|
      strategies.downcase.scan(industry.downcase).count
    end
  end
end 