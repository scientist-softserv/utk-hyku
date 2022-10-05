# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Video`
require 'rails_helper'

RSpec.describe Video do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq VideoIndexer }
  end

  include_examples "SharedWorkBehavior"
  it_behaves_like 'title validation', 'video'
end
