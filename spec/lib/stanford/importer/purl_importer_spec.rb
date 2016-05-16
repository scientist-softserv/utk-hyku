require 'rails_helper'
require 'importer'
require 'stanford'

RSpec.describe Stanford::Importer::PurlImporter do
  let(:image_directory) { 'spec/fixtures/images' }
  let(:importer) { described_class.new(image_directory) }

  before do
    ActiveFedora::Base.find('kx532cb7981').destroy(eradicate: true) if ActiveFedora::Base.exists?('kx532cb7981')
  end

  describe '#import an image' do
    let(:druid) { 'xv169dn4538' }
    before do
      ActiveFedora::Base.find('xv169dn4538').destroy(eradicate: true) if ActiveFedora::Base.exists?('xv169dn4538')
    end

    it 'creates a new image and a collection' do
      image = nil
      expect do
        image = importer.import(druid)
      end.to change { GenericWork.count }.by(1)
        .and change { Collection.count }.by(1)

      # Image.reload doesn't clear @file_association
      reloaded = GenericWork.find(image.id)

      expect(reloaded.title).to eq ['Stanford residences -- Sacramento -- Muybridge']

      expect(reloaded.read_groups).to eq ['public']

      coll = reloaded.in_collections.first
      expect(coll.id).to eq 'kx532cb7981'
      expect(coll.title).to eq ['Stanford historical photograph collection, 1887-circa 1996']
      expect(coll.members).to eq [reloaded]
      # collection is restricted until the collection object itself is ingested.
      expect(coll.visibility).to eq 'restricted'
    end

    context 'when the collection already exists' do
      let!(:coll) { FactoryGirl.create(:collection, id: 'kx532cb7981', title: ['Test Collection']) }

      it 'it adds image to existing collection' do
        expect(coll.members.size).to eq 0

        expect do
          importer.import(druid)
        end.to change { Collection.count }.by(0)

        expect(coll.reload.members.size).to eq 1
      end
    end
  end

  describe '#import a Collection' do
    let(:druid) { 'kx532cb7981' }

    it 'creates a collection' do
      coll = nil
      expect do
        coll = importer.import(druid)
      end.to change { Collection.count }.by(1)

      expect(coll.id).to eq 'kx532cb7981'
      expect(coll.title).to eq ['Stanford historical photograph collection, 1887-circa 1996 (inclusive)']
      expect(coll.read_groups).to eq ['public']

      expect(coll.contributor).to eq ['Stanford University Archives.']
    end

    context 'when the collection already exists' do
      let!(:existing) { FactoryGirl.create(:collection, id: 'kx532cb7981', title: ['Test Collection']) }

      it 'it adds metadata to existing collection' do
        coll = nil
        expect do
          coll = importer.import(druid)
        end.to change { Collection.count }.by(0)

        expect(coll.id).to eq 'kx532cb7981'
        expect(coll.title).to eq ["Stanford historical photograph collection, 1887-circa 1996 (inclusive)"]
      end
    end
  end
end
