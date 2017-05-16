class CreateFcrepoEndpointJob < ActiveJob::Base
  def perform(account)
    name = account.tenant.parameterize

    account.update(fcrepo_endpoint_attributes: { base_path: "/#{name}" })
  end
end
