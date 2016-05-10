class CreateRedisNamespaceJob < ActiveJob::Base
  def perform(account)
    name = account.tenant.parameterize

    account.update(redis_endpoint_attributes: { namespace: name })
  end
end
