RSpec.describe CreateDefaultAdminSetJob do
  describe '#perform' do
    it 'creates a new admin set for an account' do
      expect(AdminSet).to receive(:find_or_create_default_admin_set_id).once
      described_class.perform_now
    end
  end
end
