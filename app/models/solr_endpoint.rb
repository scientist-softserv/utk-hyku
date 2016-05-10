class SolrEndpoint < Endpoint
  store :options, accessors: [:url, :collection]

  def connection
    RSolr.connect(connection_options)
  end

  def connection_options
    options.reverse_merge(Blacklight.connection_config).reverse_merge(ActiveFedora::SolrService.instance.conn.options)
  end

  def switch!
    ActiveFedora::SolrService.instance.conn = connection
    Blacklight.connection_config = connection_options
    Blacklight.default_index = nil
  end

  def reset!
    ActiveFedora::SolrService.reset!
    Blacklight.connection_config = nil
    Blacklight.default_index = nil
  end
end
