# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work CompoundObject`
require 'rails_helper'

RSpec.describe CompoundObject do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq CompoundObjectIndexer }
  end

  include_examples "SharedWorkBehavior"
  it_behaves_like 'title validation', 'compound_object'
end
