require 'rails_helper'

RSpec.describe CurationConcerns::GenericWorkShowPresenter do
  let(:document) { { "has_model_ssim" => ['GenericWork'], 'id' => '99' } }
  let(:solr_document) { SolrDocument.new(document) }
  let(:request) { double(base_url: 'http://test.host') }
  let(:ability) { nil }
  let(:presenter) { described_class.new(solr_document, ability, request) }

  describe "#manifest_url" do
    subject { presenter.manifest_url }
    it { is_expected.to eq 'http://test.host/concern/generic_works/99/manifest' }
  end

  describe "file_presenter_class" do
    subject { described_class.file_presenter_class }
    it { is_expected.to eq Lerna::FileSetPresenter }
  end

  describe "representative_presenter" do
    let(:work) { FactoryGirl.create(:work_with_one_file) }
    let(:document) { work.to_solr }
    before do
      work.representative_id = work.file_sets.first.id
    end
    subject do
      presenter.representative_presenter
    end
    it "returns a presenter" do
      expect(subject).to be_kind_of Lerna::FileSetPresenter
    end
  end
end
