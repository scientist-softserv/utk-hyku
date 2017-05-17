class CreateFcrepoEndpointJob < ActiveJob::Base
  non_tenant_job

  def perform(account)
    name = account.tenant.parameterize

    account.update(fcrepo_endpoint_attributes: { base_path: "/#{name}" })
  end
end
