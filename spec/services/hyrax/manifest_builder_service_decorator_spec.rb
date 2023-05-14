# frozen_string_literal: true

RSpec.describe Hyrax::ManifestBuilderServiceDecorator, type: :decorator do
  subject(:manifest) { Hyrax::ManifestBuilderService.new.manifest_for(presenter: presenter) }

  let(:presenter) { double("Presenter") }
  let(:work_url) { 'hyku.test/concern/tests/abc' }
  let(:collection_url) { 'hyku.test/collections/123' }
  let(:title) { 'My Title' }

  before do
    allow(presenter).to receive(:human_readable_type).and_return('Generic Work')
    allow(presenter).to receive(:work_url).and_return(work_url)
    allow(presenter).to receive(:title).and_return(title)
    allow(presenter).to receive(:collection_url).and_return(collection_url)
    allow(presenter).to receive(:member_of_collection_ids).and_return(['123'])
    allow(presenter).to receive(:work_presenters).and_return([])
    allow(presenter).to receive(:file_set_presenters).and_return([])
    allow(presenter).to receive(:manifest_url).and_return('manifest_url')
  end

  it 'has the specific UTK provider' do
    expect(manifest['provider']).to eq(Hyrax::ManifestBuilderServiceDecorator::UTK_PROVIDER)
  end

  it 'has a homepage that refers to the work show page' do
    expect(manifest['homepage']).to eq [{ id: work_url, label: { none: title }, type: "Text", format: "text/html" }]
  end

  context 'partOf' do
    context 'when the work is part of a collection' do
      it 'has a partOf field that links to the collection' do
        expect(manifest['partOf']).to eq [{ id: collection_url, type: "Collection" }]
      end
    end

    context 'when the work is not part of a collection' do
      before { allow(presenter).to receive(:member_of_collection_ids).and_return([]) }

      it 'does not have a partOf field' do
        expect(manifest['partOf']).to be_nil
      end
    end
  end

  context 'behavior' do
    it 'does not have a behavior field' do
      expect(manifest).not_to have_key('behavior')
    end

    context 'when the work is a book' do
      before { allow(presenter).to receive(:human_readable_type).and_return('Book') }

      it 'has a behavior field with "paged"' do
        expect(manifest['behavior']).to eq ['paged']
      end
    end

    context 'when the work is a compound object' do
      before { allow(presenter).to receive(:human_readable_type).and_return('Compound Object') }

      it 'has a behavior field with "individuals"' do
        expect(manifest['behavior']).to eq ['individuals']
      end
    end
  end
end
