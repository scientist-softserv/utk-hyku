# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Image do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq ImageIndexer }
  end

  include_examples "SharedWorkBehavior"
  it_behaves_like 'title validation', 'image'
end
