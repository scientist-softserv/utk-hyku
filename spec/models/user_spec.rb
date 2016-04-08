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

  describe '#global_roles' do
    subject { FactoryGirl.create(:admin) }

    it 'fetches the global roles assigned to the user' do
      expect(subject.global_roles.pluck(:name)).to match_array ['admin']
    end
  end

  describe '#global_roles=' do
    subject { FactoryGirl.create(:user) }

    it 'assigns global roles to the user' do
      expect(subject.global_roles.pluck(:name)).to be_empty

      subject.update(global_roles: ['admin'])

      expect(subject.global_roles.pluck(:name)).to match_array ['admin']
    end

    it 'removes roles' do
      subject.update(global_roles: ['admin'])
      subject.update(global_roles: [])
      expect(subject.global_roles.pluck(:name)).to be_empty
    end
  end
end
