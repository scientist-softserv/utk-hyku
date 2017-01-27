class CleanupAccountJob < ActiveJob::Base
  def perform(account)
    cleanup_solr(account)
    cleanup_fedora(account)
    Apartment::Tenant.drop(account.tenant)
    account.destroy
  end

  private

    def cleanup_fedora(account)
      account.switch do
        fcrepo_client.delete(account.fcrepo_endpoint.base_path)
      end
    end

    def cleanup_solr(account)
      # A partially set up account, may never have been given a solr_endpoint.
      return unless account.solr_endpoint
      # Spin off as a job, so that it can fail and be retried separately from the other logic.
      RemoveSolrCollectionJob.perform_later(account.solr_endpoint.collection, account.solr_endpoint.connection_options)
      account.solr_endpoint.destroy
    end

    def fcrepo_client
      ActiveFedora.fedora.connection
    end
end
