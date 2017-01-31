class CleanupAccountJob < ActiveJob::Base
  def perform(account)
    account.switch do
      if account.solr_endpoint
        solr_client.get '/solr/admin/collections', params: { action: 'DELETE', name: account.solr_endpoint.collection }
      end
      fcrepo_client.delete(account.fcrepo_endpoint.base_path) if account.fcrepo_endpoint
    end

    Apartment::Tenant.drop(account.tenant)

    account.destroy
  end

  private

    def solr_client
      Blacklight.default_index.connection
    end

    def fcrepo_client
      ActiveFedora.fedora.connection
    end
end
