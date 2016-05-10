require 'rails_helper'

RSpec.describe CreateRedisNamespaceJob do
  let(:account) { FactoryGirl.create(:account) }

  describe '#perform' do
    it 'creates a new namespace for an account' do
      described_class.perform_now(account)

      expect(account.redis_endpoint.namespace).to eq account.tenant.parameterize
    end
  end
end
