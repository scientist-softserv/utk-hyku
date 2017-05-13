require 'active_job'
require 'active_job_tenant'

# Hyrax::ApplicationJob is switched into tenant context.
# ActiveJob::Base is NOT!
class Hyrax::ApplicationJob < ActiveJob::Base
  include ActiveJobTenant
end
