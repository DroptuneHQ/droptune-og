require "sidekiq/throttled"
Sidekiq::Throttled.setup!
Sidekiq::Extensions.enable_delay!

if Rails.env.production?

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] }
    config.average_scheduled_poll_interval = 1
  end

end
