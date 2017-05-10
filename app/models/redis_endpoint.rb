class RedisEndpoint < Endpoint
  store :options, accessors: [:namespace]

  def switch!
    Hyrax.config.redis_namespace = options[:namespace]
  end

  # Reset the Redis namespace back to the default value
  def self.reset!
    Hyrax.config.redis_namespace = Settings.redis.default_namespace
  end

  def ping
    redis_instance.ping
  rescue
    false
  end

  private

    def redis_instance
      Hyrax::RedisEventStore.instance
    end
end
