require 'rails_helper'

RSpec.describe User, type: :model do
  context 'the first created user' do
    subject { FactoryGirl.create(:base_user) }
    it 'is given the admin role' do
      expect(subject).to have_role :admin
    end
  end

  context 'a subsequent user' do
    let!(:first_user) { FactoryGirl.create(:base_user) }
    let!(:next_user) { FactoryGirl.create(:base_user) }

    it 'does not get the admin role' do
      expect(next_user).not_to have_role :admin
    end
  end
end
