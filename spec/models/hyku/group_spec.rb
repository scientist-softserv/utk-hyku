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

    describe '#search_members' do
    end

    describe '#add_members_by_id' do
    end

    describe '#remove_members_by_id' do
    end
  end
end
