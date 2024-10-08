# frozen_string_literal: true

# rubocop:disable BracesAroundHashParameters maybe a rubocop bug re hash params?
RSpec.describe Hyrax::IiifManifestPresenter, skip: "TODO: address in #414 - many failures in CI but not locally" do
  subject(:presenter) { described_class.new(work) }

  let(:work) { create(:image) }
  let(:account) { create(:account) }
  let(:site) { create(:site, account: account) }

  before do
    allow(site.account).to receive(:ssl_configured).and_return('https')
  end

  describe 'manifest generation' do
    let(:builder_service) { Hyrax::ManifestBuilderService.new }

    # TODO: Address in #414 - RSolr Error
    xit 'generates a IIIF presentation 3.0 manifest' do
      expect(builder_service.manifest_for(presenter: presenter)['@context'].last)
        .to eq 'http://iiif.io/api/presentation/3/context.json'
    end

    context 'with file set and work members' do
      let(:work) { create(:image_with_one_file) }

      # TODO: Address in #414
      # ArgumentError: Unknown attribute utk_binding_designer_tesim
      xit 'generates a manifest with nested content' do
        expect(builder_service.manifest_for(presenter: presenter)['items'].count)
          .to eq 1 # two image file_set members from the factory
      end

      context 'and an ability' do
        let(:ability) { Ability.new(user) }
        let(:user) { create(:user) }

        before { presenter.ability = ability }

        # TODO: Address in #414
        # ArgumentError: Unknown attribute utk_binding_designer_tesim
        xit 'excludes items the user cannot read' do
          expect(builder_service.manifest_for(presenter: presenter)['items']).to be_empty
        end
      end
    end
  end

  describe Hyrax::IiifManifestPresenter::DisplayImagePresenter do
    subject(:presenter) { described_class.new(solr_doc) }

    let(:solr_doc) { SolrDocument.new(file_set.to_solr) }
    let(:file_set) { create(:file_set, :image) }

    describe '#supplementing_content' do
      xit 'returns a IIIFManifest::V3::SupplementingContent object' do
        # TODO: test this method once this spec is fixed
      end
    end
  end

  describe '#manifest_metadata' do
    # TODO: Address in #414
    # ArgumentError: Unknown attribute utk_binding_designer_tesim
    xit 'includes empty metadata' do
      expect(presenter.manifest_metadata)
        .to contain_exactly({ "label" => "Title", "value" => ["Test title"] })
    end

    context 'with some metadata' do
      let(:work) do
        build(:book,
              title: ['Comet in Moominland'],
              creator: ['Tove Jansson'],
              rights_statement: ['free!'])
      end

      # TODO: Address in #414
      # ArgumentError: Unknown attribute utk_binding_designer_tesim
      xit 'includes configured metadata' do
        expect(presenter.manifest_metadata)
          .to contain_exactly({ "label" => "Rights Statement", "value" => ["free!"] },
                              { "label" => "Title", "value" => ["Comet in Moominland"] },
                              { "label" => "Creator", "value" => ["Tove Jansson"] })
      end
    end
  end

  describe '#manifest_url' do
    let(:work) { build(:image) }

    it 'gives an empty string for an unpersisted object' do
      expect(presenter.manifest_url).to be_empty
    end

    context 'with a persisted work' do
      let(:work) { create(:image) }

      it 'builds a url from the manifest path and work id ' do
        expect(presenter.manifest_url).to end_with "concern/images/#{work.id}/manifest"
      end
    end
  end

  describe '#work_url' do
    let(:work) { build(:image) }

    it 'does not return the url for the show page with id' do
      expect(presenter.work_url).to end_with '/concern/images'
    end

    context 'with a persisted work' do
      let(:work) { create(:image) }

      it 'return the url for the show page with id' do
        expect(presenter.work_url).to end_with "/concern/images/#{work.id}"
      end
    end
  end

  describe '#collection_url' do
    context 'when the work is not apart of a collection' do
      it 'returns an empty string' do
        expect(presenter.collection_url(work.member_of_collections.first&.id))
          .to be_empty
      end
    end

    context 'when the work is apart of a collection' do
      let(:collection) { create(:collection) }
      let(:work) { create(:image, member_of_collections: [collection]) }

      it 'return the url for the collection show page with id' do
        expect(presenter.collection_url(work.member_of_collections.first&.id))
          .to end_with "/collections/#{collection.id}"
      end
    end
  end

  describe '#labels_and_values' do
    # TODO: Address in #414. This method doesn't exist
    xit 'returns and array of AllinsonFlex::ProfileProperties' do
      expect(presenter.labels_and_values).to be_an Array
      expect(presenter.labels_and_values.map(&:class).uniq.size).to eq 1
    end
  end

  describe '#scrub' do
    it 'sanitizes values' do
      good_value = 'hello world'
      bad_value = '<script type="text/javascript">//some code</script>'
      expect(presenter.send(:scrub, good_value + bad_value)).to eq good_value
    end

    it 'does not escape &' do
      expect(presenter.send(:scrub, '&')).to eq '&'
    end
  end
end
# rubocop:enable Style/BracesAroundHashParameters
