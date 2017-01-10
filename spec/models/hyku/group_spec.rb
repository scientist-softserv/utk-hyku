require 'rails_helper'

module Hyku
  RSpec.describe Group do
    describe 'group with no members' do
      subject { described_class.new(name: name, description: description) }
      let(:name) { 'Empty Group' }
      let(:description) { 'Add members plz' }
      let(:empty_group_attributes) do
        {
          name: name,
          description: description,
          number_of_users: 0
        }
      end
      it { is_expected.to have_attributes(empty_group_attributes) }
      it { is_expected.to respond_to(:created_at) }
    end

    context '.search' do
      before(:context) do
        FactoryGirl.create(:group, name: 'IMPORTANT-GROUP-NAME')
        FactoryGirl.create(:group, description: 'IMPORTANT-GROUP-DESCRIPTION')
      end

      after(:context) do
        described_class.all.each { |group| group.destroy }
      end

      it 'should return groups that match a query on a name' do
        expect(described_class.search('IMPORTANT-GROUP-NAME').count).to eq(1)
      end

      it 'should return groups that match a query on a description' do
        expect(described_class.search('IMPORTANT-GROUP-DESCRIPTION').count).to eq(1)
      end

      it 'should return groups with a partial match' do
        expect(described_class.search('IMPORTANT-GROUP').count).to eq(2)
      end

      it 'should return an empty set when there is no match' do
        expect(described_class.search('NULL').count).to eq(0)
      end
    end

    context '#search_members' do
      subject { FactoryGirl.create(:group) }
      let(:known_user_name) { FactoryGirl.create(:user, display_name: 'Tom Cramer') }
      let(:known_user_email) { FactoryGirl.create(:user, email: 'tom@project-hydra.com') }

      before(:example) do
        subject.add_members_by_id([known_user_name.id, known_user_email.id])
      end

      after(:example) do
        User.find_by_id(known_user_name.id).destroy
        User.find_by_id(known_user_email.id).destroy
        described_class.find_by_id(subject.id).destroy
      end

      it 'should return members based on name' do
        expect(subject.search_members(known_user_name.name).count).to eq(1)
      end

      it 'should return members based on email' do
        expect(subject.search_members(known_user_email.email).count).to eq(1)
      end

      it 'should return members based on partial matches' do
        expect(subject.search_members('Tom').count).to eq(1)
      end

      it 'should return an empty set when there is no match' do
        expect(subject.search_members('Jerry').count).to eq(0)
      end
    end

    describe '#add_members_by_id' do
      subject { FactoryGirl.create(:group) }
      let(:user) { FactoryGirl.create(:user) }
      before(:example) { subject.add_members_by_id(user.id) }

      context 'single user id' do
        it 'should add one user' do
          expect(subject.members).to include(user)
        end
      end

      # This is tested in the setup of #search_members and #remove_members_by_id
      context 'collection of user ids' do
        it 'should add multiple users' do
        end
      end
    end

    describe '#remove_members_by_id' do
      subject { FactoryGirl.create(:group) }

      context 'single user id' do
        let(:user) { FactoryGirl.create(:user) }
        before { subject.add_members_by_id(user.id) }

        it 'should remove one user' do
          expect(subject.members).to include(user)
          subject.remove_members_by_id(user.id)
          expect(subject.members).to_not include(user)
        end
      end

      context 'collection of user ids' do
        let(:user_list) { FactoryGirl.create_list(:user, 3) }
        let(:user_ids) { user_list.collect { |user| user.id } }
        before { subject.add_members_by_id(user_ids) }

        it 'should remove multiple users' do
          expect(subject.members.collect{ |user| user.id }).to eq(user_ids)
          subject.remove_members_by_id(user_ids)
          expect(subject.members.count).to eq(0)
        end
      end
    end
  end
end
