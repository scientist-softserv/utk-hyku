require 'rails_helper'
require 'importer'

RSpec.describe Importer::Factory::ETDFactory do
  let(:factory) { described_class.new(attributes) }

  let(:files) { [] }
  let(:attributes) do
    {
      collection: { id: coll.id },
      files: files,
      identifier: ['123'],
      title: ['Test image'],
      read_groups: ['public'],
      depositor: 'bob',
      edit_users: ['bob']
    }
  end

  context 'with files' do
    let(:factory) { described_class.new(attributes, 'tmp/files', files) }
    let(:files) { ['img.png'] }
    let(:file) { double('the file') }
    let!(:coll) { FactoryGirl.create(:collection) }
    let(:fs_actor) { double }
    before do
      allow(File).to receive(:exist?).and_call_original # For byebug, sprockets, etc
      allow(File).to receive(:exist?).with("tmp/files/img.png").and_return(true)
      allow(File).to receive(:new).and_return(file)
      allow(CurationConcerns::Actors::FileSetActor).to receive(:new)
        .with(FileSet, User).and_return(fs_actor)
    end
    context "for a new image" do
      it 'creates file sets with access controls' do
        expect(fs_actor).to receive(:create_metadata).with(GenericWork)
        expect(fs_actor).to receive(:create_content).with(file)
        factory.run
      end
    end

    context "for an existing image without files" do
      let!(:work) { FactoryGirl.create(:generic_work) }
      let(:factory) { described_class.new(attributes.merge(id: work.id), 'tmp/files', files) }
      it 'creates file sets' do
        expect do
          expect(fs_actor).to receive(:create_metadata).with(work)
          expect(fs_actor).to receive(:create_content).with(file)
          factory.run
        end.not_to change { GenericWork.count }
      end
    end
  end

  context 'when a collection already exists' do
    let!(:coll) { FactoryGirl.create(:collection) }

    it 'does not create a new collection' do
      expect(coll.members.size).to eq 0
      expect_any_instance_of(Collection).to receive(:save!).once
      expect do
        factory.run
      end.to change { Collection.count }.by(0)
      expect(coll.reload.members.size).to eq 1
    end
  end
end
