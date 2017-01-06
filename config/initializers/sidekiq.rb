config = YAML.load(ERB.new(IO.read(Rails.root + 'config' + 'redis.yml')).result)[Rails.env].with_indifferent_access

redis_conn = if ENV['DISABLE_REDIS_CLUSTER']
               # Clustering must be disabled on AWS because it breaks Apartment switching.
               # See https://github.com/projecthydra-labs/hyku/issues/430
               proc { { url: "redis://#{config[:host]}:#{config[:port]}/" } }
             else
               proc {
                 ConnectionPool.new do
                   Redis.new url: "redis://#{config[:host]}:#{config[:port]}/", role: :master, sentinels: [(config[:sentinel] if config[:sentinel] && config[:sentinel][:host])]
                 end
               }
             end

Sidekiq.configure_server do |s|
  s.redis = redis_conn.call
end

Sidekiq.configure_client do |s|
  s.redis = redis_conn.call
end
