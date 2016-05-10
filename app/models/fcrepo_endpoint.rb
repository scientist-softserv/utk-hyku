class FcrepoEndpoint < Endpoint
  store :options, accessors: [:url, :base_path]

  def switch!
    ActiveFedora::Fedora.register(options.symbolize_keys)
  end

  def reset!
    ActiveFedora::Fedora.reset!
  end
end
