RSpec.describe CreateAccount do
  let(:account) { FactoryGirl.build(:sign_up_account) }
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

  describe '#create_account_inline' do
    it 'calls four jobs inline' do
      expect(CreateSolrCollectionJob).to receive(:perform_now).with(account)
      expect(CreateFcrepoEndpointJob).to receive(:perform_now).with(account)
      expect(CreateRedisNamespaceJob).to receive(:perform_now).with(account)
      expect(CreateDefaultAdminSetJob).to receive(:perform_now)
      subject.create_account_inline
    end
  end

  describe '#save' do
    let(:resource1) { Account.new(name: 'example', title: 'First') }
    let(:resource2) { Account.new(name: 'example', title: 'Second') }
    let(:account1) { CreateAccount.new(resource1) }
    let(:account2) { CreateAccount.new(resource2) }
    before do
      allow(account1).to receive(:create_external_resources).and_return true
      allow(account2).to receive(:create_external_resources).and_return true
    end
    it 'prevents duplicate accounts' do
      expect(account1.save).to be true
      expect(account2.save).to be false
      expect(account2.account.errors).to match a_hash_including(:cname)
    end
  end
end
