RSpec.describe CreateAccount do
  let(:account) { FactoryGirl.build(:account) }
  subject { described_class.new(account) }

  describe '#create_tenant' do
    it 'creates a new apartment tenant' do
      expect(Apartment::Tenant).to receive(:create).with(account.tenant)
      subject.create_tenant
    end

    it 'initializes the Site configuration with a link back to the Account' do
      expect(Apartment::Tenant).to receive(:create).with(account.tenant) do |&block|
        block.call
      end

      expect(Hyrax::Workflow::WorkflowImporter).to receive(:load_workflows)
      subject.create_tenant
      expect(Site.reload.account).to eq account
    end
  end

  describe '#create_solr_collection' do
    it 'queues a background job to create a solr collection for the account' do
      expect(CreateSolrCollectionJob).to receive(:perform_later).with(account)

      subject.create_solr_collection
    end
  end

  describe '#create_fcrepo_endpoint' do
    it 'has a default fcrepo endpoint configuration' do
      expect(CreateFcrepoEndpointJob).to receive(:perform_later).with(account)

      subject.create_fcrepo_endpoint
    end
  end

  describe '#create_redis_namespace' do
    it 'has a default redis namespace' do
      expect(CreateRedisNamespaceJob).to receive(:perform_later).with(account)

      subject.create_redis_namespace
    end
  end
end
