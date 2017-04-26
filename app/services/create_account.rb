# Initialize and configure external dependencies for an Account
class CreateAccount
  attr_reader :account

  ##
  # @param [Account]
  def initialize(account)
    @account = account
  end

  # @return [Boolean] true if save and jobs spawning were successful
  def save
    account.save && create_external_resources ? true : false
  end

  def create_external_resources
    create_tenant &&
      create_account_inline
    # Temporarily disabled to allow synchronous account creation
    #   create_solr_collection &&
    #   create_fcrepo_endpoint &&
    #   create_redis_namespace
  end

  ##
  # Create the apartment database tenant and initialize it with seed data
  def create_tenant
    Apartment::Tenant.create(account.tenant) do
      initialize_account_data
      Hyrax::Workflow::WorkflowImporter.load_workflows
    end
  end

  # Sacrifing idempotency of our account creation jobs here to reflect
  # the dependency that exists between creating endpoints,
  # specifically Solr and Fedora, and creation of the default Admin
  # Set.
  def create_account_inline
    CreateSolrCollectionJob.perform_now(account)
    CreateFcrepoEndpointJob.perform_now(account)
    CreateRedisNamespaceJob.perform_now(account)
    CreateDefaultAdminSetJob.perform_now
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
