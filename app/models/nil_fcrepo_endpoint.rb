class NilFcrepoEndpoint
  def switch!
    ActiveFedora::Fedora.register(options)
  end

  def ping
    false
  end

  private

    def options
      { url: 'http://127.0.0.1:99999/nil_fcrepo_endpoint' }
    end
end
