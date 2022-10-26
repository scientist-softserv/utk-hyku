# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Attachment`
require 'rails_helper'

RSpec.describe Attachment do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq AttachmentIndexer }
  end

  include_examples "SharedWorkBehavior"
  it_behaves_like 'title validation', 'attachment'
end
