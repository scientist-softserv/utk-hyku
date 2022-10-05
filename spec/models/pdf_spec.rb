# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Pdf`
require 'rails_helper'

RSpec.describe Pdf do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq PdfIndexer }
  end

  include_examples "SharedWorkBehavior"
  it_behaves_like 'title validation', 'pdf'
end
