class CreateRedisNamespaceJob < ActiveJob::Base
  non_tenant_job

  def perform(account)
    name = account.tenant.parameterize

    account.create_redis_endpoint(namespace: name)
  end
end
