class CreateAccountInlineJob < ActiveJob::Base
  def perform(account)
    CreateSolrCollectionJob.perform_now(account)
    CreateFcrepoEndpointJob.perform_now(account)
    CreateRedisNamespaceJob.perform_now(account)
    CreateDefaultAdminSetJob.perform_now(account)
  end
end
