require 'rails_helper'

RSpec.describe Role, type: :model do
  describe '.global' do
    let!(:role_a) { described_class.create(name: :a) }
    let!(:role_b) { described_class.create(name: :b) }
    let!(:role_c) { described_class.create(name: :c, resource: Site.instance) }

    it 'selects only the global roles' do
      expect(described_class.global).to match_array [role_a, role_b]
    end
  end
end
