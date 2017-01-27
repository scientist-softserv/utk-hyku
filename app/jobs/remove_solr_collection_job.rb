class RemoveSolrCollectionJob < ActiveJob::Base
  # @param collection [String] the name of the collection
  # @param connection_options [Hash] options for connecting to solr.
  # @option connection_options [String] :url
  # @option connection_options [String] :url
  def perform(collection, connection_options)
    solr_client(connection_options).get '/solr/admin/collections', params: { action: 'DELETE', name: collection }
  end

  private

    def solr_client(connection_options)
      RSolr.connect(connection_options)
    end
end
