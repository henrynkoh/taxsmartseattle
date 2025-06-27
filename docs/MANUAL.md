# TaxSmartSeattle User Manual

## Table of Contents
1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [System Architecture](#system-architecture)
4. [Dashboard Overview](#dashboard-overview)
5. [Managing Tax Tips](#managing-tax-tips)
6. [Video Production](#video-production)
7. [YouTube Integration](#youtube-integration)
8. [System Maintenance](#system-maintenance)
9. [Advanced Features](#advanced-features)
10. [Security](#security)
11. [Performance Optimization](#performance-optimization)
12. [Troubleshooting](#troubleshooting)
13. [API Documentation](#api-documentation)
14. [Integrations](#integrations)
15. [Backup and Recovery](#backup-and-recovery)

## Introduction

TaxSmartSeattle is an advanced automated system for creating and managing YouTube Shorts about tax advice, specifically targeting Korean and Asian businesses in Seattle. This comprehensive manual provides detailed instructions for using, maintaining, and extending the system.

### Purpose and Goals
- Automate tax information collection
- Generate engaging video content
- Reach Korean and Asian business owners
- Provide accurate, timely tax advice
- Build a community of informed business owners

### Target Audience
- Korean business owners in Seattle
- Asian business community
- Tax professionals
- Small business consultants
- System administrators

## Getting Started

### Initial Setup
1. System Requirements:
   ```bash
   # macOS
   brew install redis ffmpeg imagemagick node python@3.9
   pip3 install moviepy

   # Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install redis-server ffmpeg imagemagick nodejs python3.9
   pip3 install moviepy
   ```

2. Ruby Environment:
   ```bash
   # Install rbenv
   brew install rbenv ruby-build
   rbenv install 3.2.2
   rbenv global 3.2.2
   ```

3. Configure environment variables in `.env`:
   ```bash
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
   ```

4. Database Configuration:
   ```yaml
   # config/database.yml
   development:
     adapter: sqlite3
     pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
     timeout: 5000
     database: db/development.sqlite3

   production:
     adapter: postgresql
     url: <%= ENV['DATABASE_URL'] %>
     pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
   ```

5. Start required services:
   ```bash
   # Development environment
   ./bin/dev

   # Production environment
   RAILS_ENV=production rails assets:precompile
   RAILS_ENV=production rails db:migrate
   RAILS_ENV=production rails server
   ```

### First-Time Configuration

1. Google Cloud Setup:
   - Create new project in Google Cloud Console
   - Enable required APIs:
     - YouTube Data API v3
     - Cloud Text-to-Speech API
     - Cloud Storage API
     - Cloud Vision API
   - Create service account:
     - Grant YouTube Data API access
     - Download JSON credentials
     - Set up OAuth 2.0 consent screen
   - Configure API quotas:
     - YouTube API: 10,000 units/day
     - Text-to-Speech: 1 million characters/month
     - Cloud Storage: 5GB/month

2. YouTube Channel Configuration:
   - Create brand account
   - Set up YouTube channel:
     ```
     Channel Name: TaxSmartSeattle
     Description: Seattle's #1 Tax Tips for Korean and Asian Businesses
     Keywords: Seattle, Tax Tips, Korean Business, Asian Business
     ```
   - Configure upload defaults:
     - Privacy: Public
     - Category: Education
     - Language: English & Korean
   - Set up playlists:
     - Small Business Tips
     - Real Estate Tax Advice
     - Investment Tax Strategies
     - Rental Property Taxes
     - Self-employed Guidelines

3. OpenAI Configuration:
   - Set up organization
   - Create API key
   - Configure rate limits
   - Set up monitoring

## System Architecture

### Component Overview
1. Data Collection Layer:
   - Web crawlers
   - API integrators
   - Manual input system

2. Processing Layer:
   - Tax analysis engine
   - Content generator
   - Video producer

3. Distribution Layer:
   - YouTube uploader
   - Social media distributor
   - Email notifier

### Database Schema
```ruby
# Tax Tips
create_table "tax_tips", force: :cascade do |t|
  t.string "topic"
  t.string "industry"
  t.text "strategy"
  t.text "case_study"
  t.float "sentiment"
  t.string "source_url"
  t.timestamps
  t.index ["topic"], name: "index_tax_tips_on_topic"
end

# Videos
create_table "videos", force: :cascade do |t|
  t.integer "tax_tip_id"
  t.string "title"
  t.text "script"
  t.string "video_path"
  t.string "thumbnail_path"
  t.string "youtube_id"
  t.string "status"
  t.timestamps
  t.index ["tax_tip_id"], name: "index_videos_on_tax_tip_id"
end
```

### Service Integration
```ruby
# Service Configuration
config.services = {
  crawler: {
    interval: 12.hours,
    sources: ['irs.gov', 'seattletimes.com']
  },
  analyzer: {
    model: 'gpt-4',
    temperature: 0.7
  },
  video: {
    format: 'mp4',
    resolution: '1080x1920',
    framerate: 30
  }
}
```

## Dashboard Overview

### Main Dashboard Components

1. Statistics Panel:
   ```ruby
   def dashboard_stats
     {
       total_tips: TaxTip.count,
       total_videos: Video.count,
       pending_videos: Video.where(status: 'pending').count,
       total_views: Video.sum(:view_count),
       engagement_rate: calculate_engagement_rate
     }
   end
   ```

2. Recent Activity:
   - Latest tax tips
   - Recent videos
   - Failed jobs
   - System alerts

3. Performance Metrics:
   - Video views
   - Subscriber growth
   - Engagement rates
   - Processing times

4. Quick Actions:
   - Create tax tip
   - Generate video
   - Retry failed jobs
   - System health check

### Navigation Features

1. Main Menu:
   ```ruby
   def navigation_menu
     {
       dashboard: {
         path: root_path,
         icon: 'dashboard'
       },
       tax_tips: {
         path: tax_tips_path,
         icon: 'tips'
       },
       videos: {
         path: videos_path,
         icon: 'video'
       },
       analytics: {
         path: analytics_path,
         icon: 'chart'
       }
     }
   end
   ```

2. Quick Filters:
   - By industry
   - By status
   - By date range
   - By performance

3. Search Functionality:
   - Full-text search
   - Advanced filters
   - Save searches
   - Export results

## Managing Tax Tips

### Automatic Collection
- Scheduled crawling runs every Wednesday and Sunday at 6 AM
- Sources include IRS website and local news
- Tips are automatically analyzed and categorized

### Manual Review
1. Access the Tax Tips section
2. Review new tips marked as "Pending"
3. Edit or approve tips for video production
4. Assign industry categories if needed

### Industry Categories
- Small Business
- Renewable Energy
- Short-term Rental
- Real Estate
- Stock Trading
- Self-employed

## Video Production

### Script Generation
- AI-powered script creation
- Industry-specific customization
- Sentiment-based tone adjustment

### Video Creation
1. Text-to-speech conversion
2. Visual element generation
3. Video composition
4. Thumbnail creation

### Quality Control
- Review generated scripts
- Preview videos before upload
- Edit metadata if needed

## YouTube Integration

### Upload Settings
- Videos are uploaded as Shorts
- Default privacy: Public
- Automatic title and description generation
- Industry-specific tags

### Monitoring
- Track upload status
- View YouTube analytics
- Monitor viewer engagement

## System Maintenance

### Regular Tasks
1. Monitor disk space usage
2. Check log files
3. Verify service health
4. Update API credentials

### Database Management
- Regular backups
- Performance optimization
- Data cleanup

### Error Handling
- Check error logs
- Monitor failed jobs
- Retry failed uploads

## Troubleshooting

### Common Issues

1. Crawling Failures
   - Check source website availability
   - Verify network connectivity
   - Review crawler logs

2. Video Generation Issues
   - Verify FFmpeg installation
   - Check disk space
   - Monitor CPU/memory usage

3. Upload Failures
   - Verify YouTube API credentials
   - Check quota limits
   - Review upload logs

### Support Resources
- GitHub Issues
- System Documentation
- Error Log Analysis

### Emergency Procedures
1. Stop job processing
2. Backup data
3. Review error logs
4. Contact support team

## Advanced Features

## Security

## Performance Optimization

## API Documentation

## Integrations

## Backup and Recovery 