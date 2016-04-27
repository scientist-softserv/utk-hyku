require 'rails_helper'
require 'iiif_manifest'
RSpec.describe CurationConcerns::FileSetPresenter do
  let(:file_set) { FactoryGirl.create(:file_set) }
  let(:solr_document) { SolrDocument.new(file_set.to_solr) }
  let(:presenter) { described_class.new(solr_document, nil) }
  let(:id) { CGI.escape(file_set.original_file.id) }
  before do
    Hydra::Works::AddFileToFileSet.call(file_set,
                                        fixture_file('world.png'),
                                        :original_file)
  end

  describe "display_image" do
    subject { presenter.display_image }
    it "creates a display image" do
      expect(subject).to be_instance_of IIIFManifest::DisplayImage
      expect(subject.url).to eq "http://test.com/images/#{id}/full/600,/0/default.jpg"
    end
  end

  describe "iiif_endpoint" do
    subject { presenter.send(:iiif_endpoint, file_set.original_file) }
    it 'returns the url' do
      expect(subject.url).to eq "http://test.com/images/#{id}"
    end
  end
end
