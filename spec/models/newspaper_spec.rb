# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Newspaper`
require 'rails_helper'

RSpec.describe Newspaper do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq NewspaperIndexer }
  end

  include_examples "SharedWorkBehavior"
  it_behaves_like 'title validation', 'newspaper'
end
