RSpec.describe CreateAccount do
  # There are several "phases" of Account model in play here.
  # (1) The basic proto-account from the sign_up page: basically just name.  See #save below.
  # (2) The account *after* save, that has tenant and cname. This is what most methods here will see.
  # (3) A switch-read account that is what we hope to produce by the end.

  let(:account) { FactoryGirl.build(:sign_up_account, tenant: 'fresh_tenant', cname: 'fresh.localhost') }
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

  describe '#create_account_inline' do
    it 'updates endpoints' do
      name = account.tenant.parameterize
      expect(CreateSolrCollectionJob).to receive(:perform_now).with(subject.account)
      expect(account).to receive(:update).with(
        redis_endpoint_attributes: { namespace: name },
        fcrepo_endpoint_attributes: { base_path: "/#{name}" }
      )
      expect(subject.account).to receive(:switch).never # Switch is not called here
      subject.create_account_inline
    end
  end

  describe '#save' do
    let(:resource1) { Account.new(name: 'example') }
    let(:resource2) { Account.new(name: 'example') }
    let(:account1) { CreateAccount.new(resource1) }
    let(:account2) { CreateAccount.new(resource2) }
    before do
      allow(account1).to receive(:create_resources).and_return true
      allow(account2).to receive(:create_resources).and_return true
    end
    it 'prevents duplicate accounts' do
      expect(account1.save).to be true
      expect(account2.save).to be false
      expect(account2.account.errors).to match a_hash_including(:cname)
    end
  end
end
