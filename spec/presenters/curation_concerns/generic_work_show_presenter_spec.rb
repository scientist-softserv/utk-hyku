require 'rails_helper'

RSpec.describe CurationConcerns::GenericWorkShowPresenter do
  let(:document) { { "has_model_ssim" => ['GenericWork'], 'id' => '99' } }
  let(:solr_document) { SolrDocument.new(document) }
  let(:ability) { nil }
  let(:presenter) { described_class.new(solr_document, ability) }

  describe "#manifest_url" do
    subject { presenter.manifest_url }
    it { is_expected.to eq 'http://test.com/concern/generic_works/99/manifest' }
  end
end
