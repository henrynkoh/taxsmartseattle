# TaxSmartSeattle

TaxSmartSeattle is a Ruby on Rails application that automates the creation and management of YouTube Shorts focused on tax advice for Seattle-based Korean and Asian businesses. The system crawls tax information from various sources, analyzes it, generates video scripts, produces videos, and uploads them to YouTube.

## Features

- Automated tax tip collection from IRS and news sources
- Industry-specific tax strategy generation using AI
- Sentiment analysis of tax updates
- Automated video script generation
- Video production with text-to-speech and visual elements
- YouTube Shorts upload automation
- Scheduled crawling (Wednesdays and Sundays at 6 AM)
- Manual approval workflow
- Beautiful Bootstrap-based dashboard

## Prerequisites

- Ruby 3.2.2
- Rails 8.0.2
- Redis (for Sidekiq)
- SQLite3
- FFmpeg (for video processing)
- ImageMagick (for image processing)
- Google Cloud credentials (for YouTube API and Text-to-Speech)

## Environment Variables

Create a `.env` file in the root directory with the following variables:

```
REDIS_URL=redis://localhost:6379/0
OPENAI_API_KEY=your_openai_api_key
GOOGLE_APPLICATION_CREDENTIALS=path/to/your/credentials.json
```

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/taxsmartseattle.git
   cd taxsmartseattle
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   rails db:setup
   ```

4. Start the services:
   ```bash
   # In separate terminal windows:
   rails server
   redis-server
   bundle exec sidekiq
   ```

## Architecture

### Models
- `TaxTip`: Stores tax-related information
- `Video`: Manages video content and YouTube integration

### Services
- `TaxCrawler`: Fetches tax information
- `TaxAnalyzer`: Generates strategies and case studies
- `ScriptGenerator`: Creates video scripts
- `VideoProducer`: Generates videos
- `YouTubeUploader`: Handles YouTube upload

### Background Jobs
- `CrawlTaxTipsJob`: Scheduled tax tip collection
- `AnalyzeTaxTipsJob`: Tax tip analysis
- `GenerateScriptJob`: Script generation
- `ProduceVideoJob`: Video production
- `UploadVideoJob`: YouTube upload

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- OpenAI GPT-4 for tax strategy generation
- Google Cloud Text-to-Speech for audio generation
- FFmpeg for video processing
- Sidekiq for background job processing
