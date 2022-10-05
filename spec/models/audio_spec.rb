# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Audio`
require 'rails_helper'

RSpec.describe Audio do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq AudioIndexer }
  end

  include_examples "SharedWorkBehavior"
  it_behaves_like 'title validation', 'audio'
end
