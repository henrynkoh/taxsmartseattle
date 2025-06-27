# TaxSmartSeattle Tutorial

This comprehensive tutorial will guide you through setting up and mastering TaxSmartSeattle to create engaging tax advice videos for Seattle's Asian business community.

## Part 1: Basic Setup and Configuration

### Initial Setup (30 minutes)
```bash
# Clone the repository
git clone https://github.com/yourusername/taxsmartseattle.git
cd taxsmartseattle

# Install system dependencies (macOS)
brew install redis ffmpeg imagemagick node python@3.9
pip3 install moviepy

# Install system dependencies (Ubuntu)
sudo apt-get update
sudo apt-get install redis-server ffmpeg imagemagick nodejs python3.9
pip3 install moviepy

# Install Ruby dependencies
bundle install

# Set up database
rails db:setup
rails db:migrate
```

### Configuration (30 minutes)
1. Create `.env` file:
   ```bash
   # Basic settings
   REDIS_URL=redis://localhost:6379/0
   OPENAI_API_KEY=your_openai_api_key
   GOOGLE_APPLICATION_CREDENTIALS=path/to/credentials.json

   # YouTube settings
   YOUTUBE_CHANNEL_ID=your_channel_id
   YOUTUBE_API_KEY=your_api_key

   # OpenAI settings
   OPENAI_MODEL=gpt-4
   OPENAI_TEMPERATURE=0.7
   ```

2. Configure YouTube Channel:
   ```yaml
   # Channel settings
   channel_name: TaxSmartSeattle
   description: Seattle's #1 Tax Tips for Korean and Asian Businesses
   keywords: Seattle, Tax Tips, Korean Business
   default_language: en
   secondary_language: ko
   ```

3. Set up Google Cloud:
   - Create project
   - Enable APIs
   - Configure credentials
   - Set up OAuth

### Starting Services (15 minutes)
```bash
# Development mode
./bin/dev

# Production mode
RAILS_ENV=production rails assets:precompile
RAILS_ENV=production rails db:migrate
RAILS_ENV=production rails server
```

## Part 2: Creating Your First Content

### Creating a Tax Tip (20 minutes)

1. Manual Entry:
   ```ruby
   tax_tip = TaxTip.create!(
     topic: "Business Meal Deductions 2024",
     industry: "Small Business",
     strategy: "Track all business meals...",
     source_url: "https://www.irs.gov/meals"
   )
   ```

2. Using the Web Interface:
   ```
   Topic: Business Meal Deductions 2024
   Industry: Small Business
   Strategy:
   - 50% deduction for business meals
   - 100% deduction for certain cases
   - Required documentation
   Source: IRS Website
   ```

3. API Integration:
   ```ruby
   # app/controllers/api/v1/tax_tips_controller.rb
   def create
     tax_tip = TaxTip.new(tax_tip_params)
     if tax_tip.save
       AnalyzeTaxTipsJob.perform_later(tax_tip.id)
       render json: tax_tip
     else
       render json: { errors: tax_tip.errors }, status: :unprocessable_entity
     end
   end
   ```

### Generating Video Content (30 minutes)

1. Script Generation:
   ```ruby
   # Custom script template
   script_template = <<~TEMPLATE
     [0:00] Hook: "Hey Seattle business owners! Did you know about this tax saving tip?"
     
     [0:05] Introduction:
     "Today we're talking about #{tax_tip.topic}"
     
     [0:15] Main Content:
     "#{tax_tip.strategy}"
     
     [0:45] Call to Action:
     "Subscribe for more tax-saving tips!"
   TEMPLATE
   ```

2. Video Production:
   ```ruby
   # Custom video settings
   video_settings = {
     resolution: '1080x1920',
     framerate: 30,
     background_music: 'upbeat.mp3',
     transitions: ['fade', 'slide'],
     captions: true
   }
   ```

3. Thumbnail Creation:
   ```ruby
   # Custom thumbnail template
   thumbnail_settings = {
     template: 'modern',
     text_color: '#FFFFFF',
     background_color: '#2C3E50',
     font: 'Roboto-Bold'
   }
   ```

## Part 3: Advanced Features

### Custom Industry Analysis (30 minutes)

1. Industry Configuration:
   ```ruby
   # config/industries.yml
   small_business:
     keywords: ['startup', 'small business', 'retail']
     tax_forms: ['Schedule C', '1040']
     deductions: ['office', 'equipment', 'travel']
   
   real_estate:
     keywords: ['property', 'rental', 'investment']
     tax_forms: ['Schedule E', '8825']
     deductions: ['depreciation', 'repairs', 'insurance']
   ```

2. Custom Analysis Rules:
   ```ruby
   class IndustryAnalyzer
     def analyze(tax_tip)
       rules = load_industry_rules(tax_tip.industry)
       apply_rules(tax_tip, rules)
       generate_recommendations(tax_tip)
     end
   end
   ```

### Multilingual Support (30 minutes)

1. Korean Translation:
   ```ruby
   # config/locales/ko.yml
   ko:
     tax_tips:
       categories:
         small_business: "소규모 사업"
         real_estate: "부동산"
       actions:
         save: "저장"
         edit: "수정"
   ```

2. Bilingual Content:
   ```ruby
   def generate_bilingual_script(tax_tip)
     {
       english: generate_english_script(tax_tip),
       korean: generate_korean_script(tax_tip)
     }
   end
   ```

### Analytics Integration (30 minutes)

1. YouTube Analytics:
   ```ruby
   class YouTubeAnalytics
     def fetch_metrics(video)
       {
         views: fetch_view_count(video),
         likes: fetch_like_count(video),
         comments: fetch_comment_count(video),
         watch_time: fetch_watch_time(video)
       }
     end
   end
   ```

2. Performance Tracking:
   ```ruby
   class PerformanceTracker
     def track_video(video)
       metrics = fetch_metrics(video)
       store_metrics(video, metrics)
       generate_report(video)
     end
   end
   ```

## Part 4: Best Practices

### Content Strategy (20 minutes)

1. Topic Selection:
   ```ruby
   def trending_topics
     {
       small_business: ['Expense Tracking', 'Home Office'],
       real_estate: ['Depreciation', '1031 Exchange'],
       investment: ['Capital Gains', 'Loss Harvesting']
     }
   end
   ```

2. Content Calendar:
   ```ruby
   def content_schedule
     {
       monday: 'Small Business Tips',
       wednesday: 'Real Estate Focus',
       friday: 'Investment Strategies'
     }
   end
   ```

### SEO Optimization (20 minutes)

1. Title Optimization:
   ```ruby
   def optimize_title(title)
     keywords = ['Seattle', 'Tax Tips', 'Business']
     "#{title} | #{keywords.join(' ')} #shorts"
   end
   ```

2. Description Template:
   ```ruby
   def video_description(tax_tip)
     <<~DESCRIPTION
       💼 Seattle Tax Tips: #{tax_tip.topic}
       
       Key Points:
       #{tax_tip.strategy}
       
       🔔 Subscribe for daily tax tips!
       
       #SeattleBusiness #TaxTips #KoreanBusiness
     DESCRIPTION
   end
   ```

## Part 5: Maintenance and Monitoring

### System Health Checks (15 minutes)

1. Service Monitoring:
   ```ruby
   class SystemMonitor
     def check_health
       {
         redis: check_redis_connection,
         sidekiq: check_sidekiq_status,
         youtube_api: check_youtube_quota,
         openai_api: check_openai_status
       }
     end
   end
   ```

2. Error Handling:
   ```ruby
   class ErrorHandler
     def handle_error(error)
       log_error(error)
       notify_admin(error)
       retry_job_if_possible(error)
     end
   end
   ```

### Performance Optimization (15 minutes)

1. Caching Strategy:
   ```ruby
   # config/initializers/cache.rb
   Rails.application.configure do
     config.cache_store = :redis_cache_store, {
       url: ENV['REDIS_URL'],
       expires_in: 12.hours
     }
   end
   ```

2. Job Queue Management:
   ```ruby
   # config/sidekiq.yml
   :queues:
     - critical
     - default
     - low
   :limits:
     critical: 10
     default: 5
     low: 2
   ```

## Next Steps

1. Advanced Customization:
   - Create custom video templates
   - Add industry-specific analysis
   - Implement advanced analytics

2. Integration Options:
   - Connect with CRM systems
   - Add email marketing
   - Integrate social media platforms

3. Scaling Considerations:
   - Optimize database queries
   - Implement caching
   - Add load balancing

## Support Resources

- Documentation: `docs/MANUAL.md`
- API Reference: `docs/API.md`
- Community Forum: [Link]
- Issue Tracker: [Link] 