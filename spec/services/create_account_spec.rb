require 'rails_helper'

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

  describe '#load_workflows' do
    before { allow(Sipity::Workflow).to receive(:any?).and_return(workflows_exist) }
    context 'when workflows exist' do
      let(:workflows_exist) { true }
      it "does nothing" do
        expect(Hyrax::Workflow::WorkflowImporter).not_to receive(:load_workflows)
        subject.load_workflows
      end
    end

    context 'when no workflows exist' do
      let(:workflows_exist) { false }
      it "loads workflow" do
        expect(Hyrax::Workflow::WorkflowImporter).to receive(:load_workflows)
        subject.load_workflows
      end
    end
  end
end
