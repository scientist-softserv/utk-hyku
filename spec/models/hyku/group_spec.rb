require 'rails_helper'

module Hyku
  RSpec.describe Group do
    describe 'group with no members' do
      let (:name) { 'Empty Group' }
      let (:description) { 'Add members plz' }
      subject { described_class.new(name: name, description: description) }
      it { is_expected.to have_attributes(name: name, description: description, number_of_users: 0) }
    end
  end
end
