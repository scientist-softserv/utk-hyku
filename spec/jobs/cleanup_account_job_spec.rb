require 'rails_helper'

RSpec.describe CleanupAccountJob do
  let!(:account) do
    FactoryGirl.create(:account, solr_endpoint_attributes: { collection: 'x' },
                                 fcrepo_endpoint_attributes: { base_path: '/x' })
  end

  before do
    # stub switch so we don't need to worry about changing resource handles
    allow(account).to receive(:switch) do |&block|
      block.call
    end

    allow(RemoveSolrCollectionJob).to receive(:perform_later)
    allow(ActiveFedora.fedora.connection).to receive(:delete)
    allow(Apartment::Tenant).to receive(:drop).with(account.tenant)
  end

  it 'destroys the solr collection' do
    expect(RemoveSolrCollectionJob).to receive(:perform_later).with('x', hash_including('url'))
    described_class.perform_now(account)
  end

  it 'destroys the fcrepo collection' do
    expect(ActiveFedora.fedora.connection).to receive(:delete).with('/x')

    described_class.perform_now(account)
  end

  it 'destroys the tenant database' do
    expect(Apartment::Tenant).to receive(:drop).with(account.tenant)

    described_class.perform_now(account)
  end

  it 'destroys the account' do
    expect do
      described_class.perform_now(account)
    end.to change(Account, :count).by(-1)
  end
end
