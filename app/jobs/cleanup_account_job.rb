class CleanupAccountJob < ActiveJob::Base
  def perform(account)
    # Solr endpoint pulls its connection info from account directly
    cleanup_solr(account)
    # Ensure Fedora endpoint's connection established to this account
    # and ensure Redis::Namespace limited to this account's namespace
    account.switch do
      cleanup_fedora(account)
      cleanup_redis(account)
    end
    Apartment::Tenant.drop(account.tenant)
    account.destroy
  end

  private

    def cleanup_fedora(account)
      # Return immediately if fcrepo_endpoint doesn't exist
      return unless account.fcrepo_endpoint
      # Preceding slash must be removed from base_path when calling delete()
      fcrepo_client.delete(account.fcrepo_endpoint.base_path.sub!(%r{^/}, ''))
      account.fcrepo_endpoint.destroy
    end

    def cleanup_redis(account)
      # Return immediately if redis_endpoint doesn't exist
      return unless account.redis_endpoint
      # Redis::Namespace currently doesn't support flushall or flushdb.
      # See https://github.com/resque/redis-namespace/issues/56
      # So, instead we select all keys in current namespace and delete
      keys = redis_namespace.keys '*'
      return if keys.empty?
      # Delete in slices to avoid "stack level too deep" errors for large numbers of keys
      # See https://github.com/redis/redis-rb/issues/122
      keys.each_slice(1000) { |key_slice| redis_namespace.del(*key_slice) }
      account.redis_endpoint.destroy
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

    def redis_namespace
      # This is a Redis::Namespace which is already limited to account's namespace
      Hyrax::RedisEventStore.instance
    end
end
