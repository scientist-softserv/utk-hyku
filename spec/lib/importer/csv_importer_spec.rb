require 'rails_helper'
require 'importer'

RSpec.describe Importer::CSVImporter do
  let(:image_directory) { 'spec/fixtures/images' }

  context 'when the model is passed' do
    let(:csv_file) { "#{fixture_path}/csv/gse_metadata.csv" }
    let(:importer) { described_class.new(csv_file, image_directory, GenericWork) }
    it 'creates new works' do
      expect(importer).to receive(:create_fedora_objects).exactly(19).times
      importer.import_all
    end
  end

  context 'when the model specified on the row' do
    let(:csv_file) { "#{fixture_path}/csv/sample.csv" }
    let(:importer) { described_class.new(csv_file, image_directory) }
    let(:collection_factory) { double }
    let(:image_factory) { double }

    it 'creates new images and collections' do
      expect(Importer::Factory::CollectionFactory).to receive(:new)
        .with(hash_excluding(:type), image_directory)
        .and_return(collection_factory)
      expect(collection_factory).to receive(:run)
      expect(Importer::Factory::ImageFactory).to receive(:new)
        .with(hash_excluding(:type), image_directory)
        .and_return(collection_factory)
      expect(collection_factory).to receive(:run)
      expect(Importer::Factory::ETDFactory).to receive(:new)
        .with(hash_excluding(:type), image_directory)
        .and_return(image_factory)
      expect(image_factory).to receive(:run)
      importer.import_all
    end
  end
end
