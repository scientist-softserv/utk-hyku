RSpec.describe WorkIndexer do
  describe 'thumbnail_path_service' do
    subject { described_class.thumbnail_path_service }
    it { is_expected.to eq IIIFThumbnailPathService }
  end
  describe 'rdf_service' do
    subject { described_class.new(FactoryGirl.build(:work)).rdf_service }
    it { is_expected.to eq Hyrax::BasicMetadataIndexer }
  end
end
