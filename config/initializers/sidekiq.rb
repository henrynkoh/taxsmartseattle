require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
  
  # Load the schedule
  config.on(:startup) do
    Sidekiq.schedule = {
      'crawl_tax_tips' => {
        'cron' => '0 6 * * 0,3',  # Every Wednesday and Sunday at 6 AM
        'class' => 'CrawlTaxTipsJob',
        'queue' => 'default',
        'description' => 'Crawl tax tips from various sources'
      }
    }
    
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end 