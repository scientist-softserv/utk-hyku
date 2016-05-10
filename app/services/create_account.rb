# Initialize and configure external dependencies for an Account
class CreateAccount
  attr_reader :account

  ##
  # @param [Account]
  def initialize(account)
    @account = account
  end

  def save
    account.save && create_external_resources
  end

  def create_external_resources
    create_tenant &&
      create_solr_collection &&
      create_fcrepo_endpoint &&
      create_redis_namespace &&
      account.save
  end

  ##
  # Create the apartment database tenant and initialize it with seed data
  def create_tenant
    Apartment::Tenant.create(account.tenant) do
      initialize_account_data
    end
  end

  def create_solr_collection
    CreateSolrCollectionJob.perform_later(account)
  end

  def create_fcrepo_endpoint
    CreateFcrepoEndpointJob.perform_later(account)
  end

  def create_redis_namespace
    CreateRedisNamespaceJob.perform_later(account)
  end

  private

    def initialize_account_data
      Site.update(account: account)
    end
end
