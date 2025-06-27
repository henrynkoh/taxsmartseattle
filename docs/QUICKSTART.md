# TaxSmartSeattle QuickStart Guide

Get up and running with TaxSmartSeattle in under 5 minutes! This guide provides step-by-step instructions for setting up and using the system.

## Prerequisites (1 minute)

### System Requirements
```bash
# Check Ruby version (needs 3.2.2+)
ruby -v

# Check Node.js version (needs 16+)
node -v

# Check Python version (needs 3.9+)
python3 --version

# Check Redis
redis-cli ping  # Should return PONG
```

### Required API Keys
1. OpenAI API Key
   ```bash
   # Test OpenAI API key
   curl https://api.openai.com/v1/models \
     -H "Authorization: Bearer $OPENAI_API_KEY"
   ```

2. Google Cloud Credentials
   ```bash
   # Verify Google credentials
   gcloud auth application-default print-access-token
   ```

3. YouTube API Access
   ```bash
   # Test YouTube API
   curl \
     'https://youtube.googleapis.com/youtube/v3/channels?part=snippet&mine=true' \
     --header "Authorization: Bearer $YOUTUBE_ACCESS_TOKEN"
   ```

## Installation (2 minutes)

### 1. Clone and Setup
```bash
# Clone repository
git clone https://github.com/yourusername/taxsmartseattle.git
cd taxsmartseattle

# Install dependencies
bundle install
yarn install
pip3 install -r requirements.txt

# Setup database
rails db:setup
rails db:migrate
```

### 2. Configuration
```bash
# Create .env file
cat > .env << EOL
# Basic Configuration
REDIS_URL=redis://localhost:6379/0
OPENAI_API_KEY=your_openai_api_key
GOOGLE_APPLICATION_CREDENTIALS=path/to/credentials.json

# YouTube Configuration
YOUTUBE_CHANNEL_ID=your_channel_id
YOUTUBE_API_KEY=your_api_key

# OpenAI Configuration
OPENAI_MODEL=gpt-4
OPENAI_TEMPERATURE=0.7

# Email Configuration
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email
SMTP_PASSWORD=your_password
EOL
```

### 3. Start Services
```bash
# Development mode
./bin/dev

# Or start services individually
redis-server &
bundle exec sidekiq &
rails server
```

## Quick Test (1 minute)

### 1. Create Test Tax Tip
```ruby
# Via Rails console
rails console
tip = TaxTip.create!(
  topic: "Business Meal Deductions",
  industry: "Small Business",
  strategy: "Track all business meals with receipts and notes",
  source_url: "https://www.irs.gov/meals"
)
```

### 2. Generate Test Video
```ruby
# Via Rails console
video = Video.create!(
  tax_tip: tip,
  title: "Save Money on Business Meals",
  status: "pending"
)
GenerateScriptJob.perform_later(video.id)
```

### 3. Monitor Progress
```bash
# Check Sidekiq queue
curl localhost:3000/sidekiq

# Check logs
tail -f log/development.log
```

## Basic Usage (1 minute)

### Web Interface
1. Visit `http://localhost:3000`
2. Login with default credentials:
   ```
   Email: admin@example.com
   Password: password
   ```
3. Navigate the dashboard:
   ```ruby
   # Available routes
   routes = {
     dashboard: "/",
     tax_tips: "/tax_tips",
     videos: "/videos",
     analytics: "/analytics"
   }
   ```

### API Endpoints
```ruby
# Available endpoints
endpoints = {
  tax_tips: {
    list: "GET /api/v1/tax_tips",
    create: "POST /api/v1/tax_tips",
    show: "GET /api/v1/tax_tips/:id"
  },
  videos: {
    list: "GET /api/v1/videos",
    create: "POST /api/v1/videos",
    show: "GET /api/v1/videos/:id"
  }
}

# Example API call
curl -X POST http://localhost:3000/api/v1/tax_tips \
  -H "Content-Type: application/json" \
  -d '{
    "tax_tip": {
      "topic": "Business Meal Deductions",
      "industry": "Small Business",
      "strategy": "Track all business meals"
    }
  }'
```

## Common Operations

### Creating Content
```ruby
# Create tax tip
tax_tip = TaxTip.create!(
  topic: "Home Office Deduction",
  industry: "Self-employed",
  strategy: "Calculate square footage used for business"
)

# Generate video
video = Video.create!(tax_tip: tax_tip)
GenerateScriptJob.perform_later(video.id)
```

### Monitoring Jobs
```ruby
# Check job status
Sidekiq::Queue.new.size  # Number of pending jobs
Sidekiq::Workers.new.size  # Number of working jobs

# Check failed jobs
Sidekiq::DeadSet.new.size  # Number of failed jobs
```

### System Health
```ruby
# Check system status
status = {
  redis: Redis.new.ping == "PONG",
  sidekiq: Sidekiq::ProcessSet.new.size > 0,
  database: ActiveRecord::Base.connection.active?
}

# Check API quotas
quotas = {
  youtube: YouTubeService.new.quota_remaining,
  openai: OpenAiService.new.quota_remaining
}
```

## Troubleshooting

### Common Issues
1. Redis Connection:
   ```bash
   # Restart Redis
   brew services restart redis  # macOS
   sudo service redis restart  # Ubuntu
   ```

2. Sidekiq Issues:
   ```bash
   # Clear all jobs
   Sidekiq::Queue.new.clear
   
   # Retry failed jobs
   Sidekiq::DeadSet.new.retry_all
   ```

3. Database Issues:
   ```bash
   # Reset database
   rails db:reset
   
   # Run migrations
   rails db:migrate
   ```

### Error Codes
```ruby
error_codes = {
  "YOUTUBE001": "YouTube API quota exceeded",
  "OPENAI001": "OpenAI API error",
  "REDIS001": "Redis connection error",
  "DB001": "Database connection error"
}
```

## Next Steps

### 1. Customize Content
```ruby
# Modify video settings
config.video_settings = {
  resolution: "1080x1920",
  framerate: 30,
  duration: 60
}

# Add custom templates
config.templates = {
  script: "path/to/script_template.erb",
  thumbnail: "path/to/thumbnail_template.erb"
}
```

### 2. Setup Monitoring
```ruby
# Configure monitoring
config.monitoring = {
  slack_webhook: ENV['SLACK_WEBHOOK'],
  error_notification: true,
  performance_alerts: true
}
```

### 3. Scale System
```ruby
# Configure scaling
config.scaling = {
  sidekiq_concurrency: 5,
  max_queue_size: 100,
  job_timeout: 30.minutes
}
```

## Support Resources

### Documentation
- Full Manual: `docs/MANUAL.md`
- API Reference: `docs/API.md`
- Tutorial: `docs/TUTORIAL.md`

### Community
- GitHub Issues: [Link]
- Discussion Forum: [Link]
- Email Support: support@taxsmartseattle.com

### Updates
- Release Notes: `CHANGELOG.md`
- Roadmap: `ROADMAP.md`
- Security: `SECURITY.md` 