# frozen_string_literal: true

require 'importer'
require 'importer/mods_parser'

RSpec.describe Importer::ModsImporter, :clean do
  let(:image_directory) { File.join(fixture_path, 'images') }
  let(:importer) { described_class.new(image_directory) }
  let(:actor) { double }

  before do
    allow(Hyrax::CurationConcern).to receive(:actor).and_return(actor)
  end

  describe '#import an image' do
    let(:file) { File.join(fixture_path, 'mods', 'shpc', 'druid_xv169dn4538.mods') }

    # TODO: Address in #414
    # k.attributes => {"title"=>
    #   ["Stanford residences -- Sacramento -- Muybridge"],
    #  "id"=>"xv169dn4538",
    #  "visibility"=>"open",
    #  "member_of_collection_attributes"=>
    #   [{"id"=>"kx532cb7981"}]}
    xit 'creates a new image and a collection' do
      expect(actor).to receive(:create).with(Hyrax::Actors::Environment) do |k|
        expect(k.attributes).to include(member_of_collection_attributes: [{ id: 'kx532cb7981' }],
                                        identifier: ['xv169dn4538'],
                                        visibility: 'open')
      end
      expect do
        importer.import(file)
      end.to change(Collection, :count).by(1)

      coll = Collection.last
      expect(coll.identifier).to eq ['kx532cb7981']
      expect(coll.title).to eq ['Stanford historical photograph collection, 1887-circa 1996']
      expect(coll.visibility).to eq 'open'
    end

    context 'when the collection already exists' do
      let!(:coll) { create(:collection, id: 'kx532cb7981', title: ['Test Collection']) }

      it 'adds image to existing collection' do
        expect(actor).to receive(:create).with(Hyrax::Actors::Environment) do |k|
          expect(k.attributes).to include(member_of_collection_attributes: [{ id: coll.id }])
        end
        expect do
          importer.import(file)
        end.to change(Collection, :count).by(0)
      end
    end
  end

  describe '#import a Collection' do
    let(:file) { File.join(fixture_path, 'mods', 'shpc', 'kx532cb7981.mods') }

    # TODO: Address in #414
    # ArgumentError: You attempted to set the property `extent' of kx532cb7981 to an enumerable value.
    # However, this property is declared as singular.
    xit 'creates a collection' do
      coll = nil
      expect do
        coll = importer.import(file)
      end.to change(Collection, :count).by(1)

      expect(coll.identifier).to eq ['kx532cb7981']
      expect(coll.title).to eq ['Stanford historical photograph collection, 1887-circa 1996 (inclusive)']
      expect(coll.read_groups).to eq ['public']

      expect(coll.contributor).to eq ['Stanford University — Archives.']
    end

    context 'when the collection already exists' do
      let!(:existing) { FactoryBot.create(:collection, id: 'kx532cb7981', title: ['Test Collection']) }

      # TODO: Address in #414
      # ArgumentError: You attempted to set the property `extent' of kx532cb7981 to an enumerable value.
      # However, this property is declared as singular.
      xit 'adds metadata to existing collection' do
        coll = nil
        expect do
          coll = importer.import(file)
        end.to change(Collection, :count).by(0)

        expect(coll.id).to eq existing.id
        expect(coll.identifier).to eq ['kx532cb7981']
        expect(coll.title).to eq ["Stanford historical photograph collection, 1887-circa 1996 (inclusive)"]
      end
    end
  end
end
