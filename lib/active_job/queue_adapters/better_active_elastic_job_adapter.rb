require 'active_elastic_job'

module ActiveJob
  module QueueAdapters
    class BetterActiveElasticJobAdapter < ActiveElasticJobAdapter
      class << self
        private

          def queue_url(*_)
            if Settings.active_job_queue.url
              Settings.active_job_queue.url
            else
              super
            end
          end
      end
    end
  end
end
