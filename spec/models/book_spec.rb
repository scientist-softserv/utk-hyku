# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Book`
require 'rails_helper'

RSpec.describe Book do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq BookIndexer }
  end

  include_examples "SharedWorkBehavior"
  it_behaves_like 'title validation', 'book'
end
