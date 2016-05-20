require 'rails_helper'

RSpec.describe CurationConcerns::GenericWorkShowPresenter do
  let(:document) { { "has_model_ssim" => ['GenericWork'], 'id' => '99' } }
  let(:solr_document) { SolrDocument.new(document) }
  let(:hostname) { 'http://test.host' }
  let(:ability) { nil }
  let(:presenter) { described_class.new(solr_document, ability, hostname) }

  describe "#manifest_url" do
    subject { presenter.manifest_url }
    it { is_expected.to eq 'http://test.host/concern/generic_works/99/manifest' }
  end

  describe "file_presenter_class" do
    subject { described_class.file_presenter_class }
    it { is_expected.to eq Hybox::FileSetPresenter }
  end
end
