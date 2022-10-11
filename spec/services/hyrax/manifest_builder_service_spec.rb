# frozen_string_literal: true

# OVERRIDE Hyrax 3.4.1 to run specs
RSpec.describe Hyrax::ManifestBuilderService, :clean_repo do
  # Presenters requires a whole lot of context and therefore a whole lot of preamble
  subject do
    described_class.new(iiif_manifest_factory: ::IIIFManifest::V3::ManifestFactory)
  end

  let(:presenter) { Hyrax::IiifManifestPresenter.new(work) }
  let(:work) do
    create(
      :image_with_one_file,
      abstract: ['Details'],
      photographer: ['Kirk'],
      rights_statement: ['free!']
    )
  end
  let(:account) { create(:account) }
  let(:site) { create(:site, account: account) }

  before do
    allow(site.account).to receive(:ssl_configured).and_return('https')
  end

  describe '#manifest_for' do
    let(:manifest) { subject.manifest_for(presenter: presenter) }

    it 'is a Ruby hash' do
      expect(Rails.cache).not_to receive(:fetch)
      expect(manifest).to be_a(Hash)
    end

    it 'has an "@context" property with http://iiif.io/api/presentation/3/context.json as the last value' do
      expect(manifest['@context'].last).to eq 'http://iiif.io/api/presentation/3/context.json'
    end

    it 'has an "id" property that is a technical property that identifies the resource' do
      expect(manifest['id']).to eq presenter.manifest_url
    end

    it 'has a "type" property that describes the type of class of the resource' do
      expect(manifest['type']).to eq 'Manifest'
    end

    it 'has a "label" property value that MUST be a JSON object and TITLE OF OBJECT' do
      expect(manifest['label']).to be_a Hash
      expect(manifest['label'].values.first).to be_an Array
      expect(manifest['label'].values.first.inspect).to eq presenter.title.inspect
    end

    it 'has a "summary" property', skip: 'TODO: make this pass' do
      expect(manifest['summary']).to be_a Hash
      expect(manifest['summary'].values.first).to be_an Array
      expect(manifest['summary'].values.first).to eq presenter.abstract
    end

    it 'has a UTK specific "provider" property' do
      expect(manifest['provider'][0][:label][:en][0]).to eq 'University of Tennessee, Knoxville. Libraries'
    end

    it 'has an "items" property that includes the list of child resources of the manifest' do
      expect(manifest['items']).to be_an Array
      expect(manifest['items'][0]['type']).to eq 'Canvas'
      expect(manifest['items'][0]['items'][0]['type']).to eq 'AnnotationPage'
      expect(manifest['items'][0]['items'][0]['items'][0]['type']).to eq 'Annotation'
      expect(manifest['items'][0]['items'][0]['items'][0]['body']['type']).to eq 'Image'
    end

    context 'when apart of a collection' do
      let(:collection) { create(:collection) }
      let(:work) { create(:image, member_of_collections: [collection]) }

      it 'has a "partOf" property that lists the IIIF resources that contain this one' do
        expect(manifest['partOf'][0][:id]).to end_with "/collections/#{collection.id}"
      end
    end

    it 'has a "homepage" property that points to the show page' do
      expect(manifest['homepage'][0][:id]).to eq "http://localhost/concern/images/#{work.id}"
    end

    it 'has a "metadata" property that is a pairs of human readable label and value entries' do
      expect(manifest['metadata']).to be_an Array
      expect(manifest['metadata'][0].keys).to eq ['label', 'value']
      expect(manifest['metadata'][-1]['label'].values[0].first).to eq 'Photographer'
      expect(manifest['metadata'][-1]['value'].values[0].first).to eq 'Kirk'
    end

    it 'has a "rights" property that is a string' do
      expect(manifest['rights']).to be_a String
      expect(manifest['rights']).to eq presenter.rights_statement.first
    end
  end
end
# rubocop:enable Metrics/BlockLength
