config = YAML.load(ERB.new(IO.read(Rails.root + 'config' + 'redis.yml')).result)[Rails.env].with_indifferent_access
sentinels = config[:sentinel] && config[:sentinel][:host].present? ? { sentinels: [config[:sentinel]] } : {}
redis_config = config.except(:sentinel).merge(thread_safe: true).merge(sentinels)

redis_conn = if ENV['DISABLE_REDIS_CLUSTER']
               # Clustering must be disabled on AWS because it breaks Apartment switching.
               # See https://github.com/projecthydra-labs/hyku/issues/430
               proc { redis_config }
             else
               proc {
                 ConnectionPool.new do
                   Redis.new redis_config.merge(role: :master)
                 end
               }
             end

Sidekiq.configure_server do |s|
  s.redis = redis_conn.call
end

Sidekiq.configure_client do |s|
  s.redis = redis_conn.call
end
