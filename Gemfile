source "https://rubygems.org"

ruby "3.2.2"

# Rails core
gem "rails", "~> 8.0.2"

# Database
gem "sqlite3", ">= 2.1"

# Server
gem "puma", ">= 5.0"

# Asset Pipeline
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Background Jobs
gem "sidekiq", "~> 7.0"
gem "sidekiq-scheduler"

# API Clients
gem "google-apis-youtube_v3"
gem "httparty"

# Web Scraping
gem "nokogiri"

# Environment Variables
gem "dotenv-rails"

# Utilities
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Text to Speech
gem "google-cloud-text_to_speech"

# Video Processing
gem "streamio-ffmpeg"
gem "mini_magick"
gem "carrierwave"

# Natural Language Processing
gem "ruby-openai"
gem "sentimental"

# Frontend
gem "bootstrap", "~> 5.3"
gem "sassc-rails"
gem "jquery-rails"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
