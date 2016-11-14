config = YAML.load(ERB.new(IO.read(Rails.root + 'config' + 'redis.yml')).result)[Rails.env].with_indifferent_access

Sidekiq.configure_server do |s|
  s.redis = { url: "redis://#{config[:host]}:#{config[:port]}/" }
end

Sidekiq.configure_client do |s|
  s.redis = { url: "redis://#{config[:host]}:#{config[:port]}/" }
end
