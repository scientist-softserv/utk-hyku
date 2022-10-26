# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Collection do
  let(:user) { create(:user).tap { |u| u.add_role(:admin, Site.instance) } }
  let(:account) { create(:account) }
  let(:collection) { create(:collection, user: user) }

  before do
    Site.update(account: account)
  end

  it 'is a hyrax collection' do
    expect(described_class.ancestors).to include Hyrax::CollectionBehavior
  end

  describe '.indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq CollectionIndexer }
  end

  context 'metadata properties' do
    subject { build :collection }

    let(:collection) { build(:collection) }

    it { is_expected.to have_property(:abstract) }
    it {
      is_expected.to have_property(:bulkrax_identifier)
        .with_predicate('https://hykucommons.org/terms/bulkrax_identifier')
    }
    it { is_expected.to have_property(:collection_link).with_predicate('http://purl.org/ontology/bibo/Collection') }
    it { is_expected.to have_property(:creator) }
    it { is_expected.to have_property(:date_created) }
    it { is_expected.to have_property(:date_created_d).with_predicate('https://dbpedia.org/ontology/completionDate') }
    it { is_expected.to have_property(:date_issued).with_predicate('http://purl.org/dc/terms/issued') }
    it { is_expected.to have_property(:date_issued_d).with_predicate('https://dbpedia.org/ontology/publicationDate') }
    it { is_expected.to have_property(:extent).with_predicate('http://rdaregistry.info/Elements/u/P60550') }
    it { is_expected.to have_property(:form).with_predicate('http://www.europeana.eu/schemas/edm/hasType') }
    it { is_expected.to have_property(:keyword) }
    it { is_expected.to have_property(:license) }
    it { is_expected.to have_property(:publication_place).with_predicate('https://id.loc.gov/vocabulary/relators/pup') }
    it { is_expected.to have_property(:publisher) }
    it { is_expected.to have_property(:repository).with_predicate('http://id.loc.gov/vocabulary/relators/rps') }
    it { is_expected.to have_property(:resource_type) }
    it { is_expected.to have_property(:rights_statement) }
    it { is_expected.to have_property(:spatial).with_predicate('http://purl.org/dc/terms/spatial') }
    it { is_expected.to have_property(:subject) }
    it { is_expected.to have_property(:title) }
    it { is_expected.to have_property(:utk_contributor).with_predicate('https://ontology.lib.utk.edu/roles#ctb') }
    it { is_expected.to have_property(:utk_creator).with_predicate('https://ontology.lib.utk.edu/roles#cre') }
    it { is_expected.to have_property(:utk_publisher).with_predicate('https://ontology.lib.utk.edu/roles#pbl') }
  end

  describe 'Featured Collections' do
    before do
      FeaturedCollection.create(collection_id: collection.id)
    end

    describe '#update' do
      context 'when collection is public' do
        let(:collection) { create(:public_collection) }

        it 'does not remove the collection from featured collections' do
          expect(collection).not_to receive(:remove_featured)
          collection.update(title: ['New collection title'])
        end
      end

      context 'when collection is private' do
        let(:collection) { create(:private_collection) }

        it 'removes collection from featured collections' do
          expect(collection).to receive(:remove_featured)
          collection.update(title: ['New collection title'])
        end
      end

      context 'when collection is changed from public to private' do
        let(:collection) { create(:public_collection) }

        it 'removes collection from featured collections' do
          expect(collection).to receive(:remove_featured)
          collection.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
          collection.save!
        end
      end
    end

    describe '#destroy' do
      it 'deletes the featured collection after destroying the collection' do
        expect(collection).to receive(:remove_featured)
        collection.destroy
      end
    end

    describe '#remove_featured' do
      it 'removes collection from featured collections' do
        expect(FeaturedCollection.where(collection_id: collection.id).count).to eq(1)
        collection.remove_featured
        expect(FeaturedCollection.where(collection_id: collection.id).count).to eq(0)
      end
    end
  end
end
