# Create a new account-specific Solr collection using the base templates
class CreateSolrCollectionJob < ActiveJob::Base
  ##
  # @param [Account]
  def perform(account)
    name = account.tenant.parameterize

    unless collection_exists? name
      client.get '/solr/admin/collections', params: collection_options.merge(action: 'CREATE',
                                                                             name: name)
    end

    account.update(solr_endpoint_attributes: { url: collection_url(name), collection: name })
  end

  private

    def client
      Blacklight.default_index.connection
    end

    def collection_options
      Settings.solr.collection_options.to_h.reject { |_k, v| v.blank? }
    end

    def collection_exists?(name)
      response = client.get '/solr/admin/collections', params: { action: 'LIST' }
      collections = response['collections']

      collections.include? name
    end

    def collection_url(name)
      normalized_uri = if Settings.solr.url.ends_with?('/')
                         Settings.solr.url
                       else
                         "#{Settings.solr.url}/"
                       end

      uri = URI(normalized_uri) + name

      uri.to_s
    end
end
