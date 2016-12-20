require 'rails_helper'
require 'importer'
require 'importer/mods_parser'

RSpec.describe Importer::ModsImporter, :clean do
  let(:image_directory) { 'spec/fixtures/images' }
  let(:importer) { described_class.new(image_directory) }

  describe '#import an image' do
    let(:file) { 'spec/fixtures/mods/shpc/druid_xv169dn4538.mods' }

    it 'creates a new image and a collection' do
      image = nil
      expect do
        image = importer.import(file)
      end.to change { GenericWork.count }.by(1)
        .and change { Collection.count }.by(1)

      # Image.reload doesn't clear @file_association
      reloaded = GenericWork.find(image.id)

      expect(reloaded.identifier).to eq ['xv169dn4538']

      expect(reloaded.read_groups).to eq ['public']

      coll = reloaded.in_collections.first
      expect(coll.identifier).to eq ['kx532cb7981']
      expect(coll.title).to eq ['Stanford historical photograph collection, 1887-circa 1996']
      expect(coll.members).to eq [reloaded]
      expect(coll.visibility).to eq 'open'
    end

    context 'when the collection already exists' do
      let!(:coll) { FactoryGirl.create(:collection, id: 'kx532cb7981', title: ['Test Collection']) }

      it 'it adds image to existing collection' do
        expect(coll.members.size).to eq 0

        expect do
          importer.import(file)
        end.to change { Collection.count }.by(0)

        expect(coll.reload.members.size).to eq 1
      end
    end
  end

  describe '#import a Collection' do
    let(:file) { 'spec/fixtures/mods/shpc/kx532cb7981.mods' }

    it 'creates a collection' do
      coll = nil
      expect do
        coll = importer.import(file)
      end.to change { Collection.count }.by(1)

      expect(coll.identifier).to eq ['kx532cb7981']
      expect(coll.title).to eq ['Stanford historical photograph collection, 1887-circa 1996 (inclusive)']
      expect(coll.read_groups).to eq ['public']

      expect(coll.contributor).to eq ['Stanford University — Archives.']
    end

    context 'when the collection already exists' do
      let!(:existing) { FactoryGirl.create(:collection, id: 'kx532cb7981', title: ['Test Collection']) }

      it 'it adds metadata to existing collection' do
        coll = nil
        expect do
          coll = importer.import(file)
        end.to change { Collection.count }.by(0)

        expect(coll.id).to eq existing.id
        expect(coll.identifier).to eq ['kx532cb7981']
        expect(coll.title).to eq ["Stanford historical photograph collection, 1887-circa 1996 (inclusive)"]
      end
    end
  end
end
