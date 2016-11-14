config = YAML.load(ERB.new(IO.read(Rails.root + 'config' + 'redis.yml')).result)[Rails.env].with_indifferent_access
require 'redis'
Redis.current = begin
                  Redis.new(config.merge(thread_safe: true))
                rescue
                  nil
                end
