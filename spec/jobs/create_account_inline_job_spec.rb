RSpec.describe CreateAccountInlineJob do
  let(:account) { FactoryGirl.create(:account) }

  describe '#perform' do
    it 'calls four other jobs synchronously' do
      expect(CreateSolrCollectionJob).to receive(:perform_now).with(account)
      expect(CreateFcrepoEndpointJob).to receive(:perform_now).with(account)
      expect(CreateRedisNamespaceJob).to receive(:perform_now).with(account)
      expect(CreateDefaultAdminSetJob).to receive(:perform_now)
      described_class.perform_now(account)
    end
  end
end
