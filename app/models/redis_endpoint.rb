class RedisEndpoint < Endpoint
  store :options, accessors: [:namespace]

  def switch!
    Sufia.config.redis_namespace = options[:namespace]
  end

  # Reset the Redis namespace back to the default value
  def reset!
    Sufia.config.redis_namespace = Settings.redis.namespace
  end

  private

    def redis_instance
      Sufia::RedisEventStore.instance
    end
end
