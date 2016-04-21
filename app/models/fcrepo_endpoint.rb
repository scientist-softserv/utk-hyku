class FcrepoEndpoint < Endpoint
  store :options, accessors: [:url, :base_path]

  def self.default_options
    ActiveFedora.fedora_config.credentials.slice(:url, :base_path)
  end

  def switch!
    ActiveFedora::Fedora.register(options.symbolize_keys)
  end

  def reset!
    ActiveFedora::Fedora.reset!
  end
end
