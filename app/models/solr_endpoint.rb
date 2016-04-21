class SolrEndpoint < Endpoint
  store :options, accessors: [:url, :collection]

  def self.default_options
    ActiveFedora::SolrService.instance.conn.options.slice(:url)
  end

  def connection
    RSolr.connect(connection_options)
  end

  def connection_options
    options.reverse_merge(ActiveFedora::SolrService.instance.conn.options)
  end

  def switch!
    ActiveFedora::SolrService.instance.conn = connection
    Blacklight.instance_variable_set(:@default_index, connection)
  end

  def reset!
    ActiveFedora::SolrService.reset!
    Blacklight.instance_variable_set(:@default_index, nil)
  end
end
