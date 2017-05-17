class CreateRedisNamespaceJob < ActiveJob::Base
  non_tenant_job

  def perform(account)
    name = account.tenant.parameterize

    account.update(redis_endpoint_attributes: { namespace: name })
  end
end
