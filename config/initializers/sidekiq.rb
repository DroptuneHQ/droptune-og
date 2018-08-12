require "sidekiq/throttled"
Sidekiq::Throttled.setup!

if Rails.env.production?

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] }
    config.average_scheduled_poll_interval = 1


    # TODO: This should really be turned on to autoscale the number of DB connections available to sidekiq
    # Rails.application.config.after_initialize do
    #   Rails.logger.info("DB Connection Pool size for Sidekiq Server before disconnect is: #{ActiveRecord::Base.connection.pool.instance_variable_get("@size")}".yellow)
    #   ActiveRecord::Base.connection_pool.disconnect!
    #
    #   ActiveSupport.on_load(:active_record) do
    #     config = Rails.application.config.database_configuration[Rails.env]
    #     config["pool"] = Sidekiq.options[:concurrency] + 2
    #     ActiveRecord::Base.establish_connection(config)
    #
    #     Rails.logger.info("DB Connection Pool size for Sidekiq Server is now: #{ActiveRecord::Base.connection.pool.instance_variable_get("@size")}".yellow)
    #   end
    # end
  end

end
