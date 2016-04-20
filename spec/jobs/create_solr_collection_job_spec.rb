require 'rails_helper'

RSpec.describe CreateSolrCollectionJob do
  let(:account) { FactoryGirl.create(:account) }
  let(:client) { double }

  before do
    allow(Blacklight.default_index).to receive(:connection).and_return(client)
  end

  describe '#perform' do
    it 'creates a new collection for an account' do
      expect(client).to receive(:get).with('/solr/admin/collections',
                                           params: { action: 'LIST' }).and_return('collections' => [])

      expect(client).to receive(:get).with('/solr/admin/collections',
                                           params: hash_including(action: 'CREATE',
                                                                  name: account.tenant,
                                                                  'collection.configName': 'hybox'))
      described_class.perform_now(account)

      expect(account.solr_endpoint.url).to eq "#{Settings.solr.url}#{account.tenant}"
    end

    it 'is idempotent' do
      expect(client).to receive(:get).with('/solr/admin/collections',
                                           params: { action: 'LIST' }).and_return('collections' => [account.tenant])

      expect(client).not_to receive(:get).with('/solr/admin/collections', params: hash_including(action: 'CREATE'))

      described_class.perform_now(account)
    end
  end
end
