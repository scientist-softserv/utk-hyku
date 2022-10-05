# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'

RSpec.describe GenericWork do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq GenericWorkIndexer }
  end

  include_examples "SharedWorkBehavior"
  it_behaves_like 'title validation', 'generic_work'
end
