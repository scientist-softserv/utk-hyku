# frozen_string_literal: true

# Generated by hyrax:models
class Collection < ActiveFedora::Base
  include ::Hyrax::CollectionBehavior
  # You can replace these metadata if they're not suitable

  property :bulkrax_identifier,
           predicate: ::RDF::URI('https://hykucommons.org/terms/bulkrax_identifier'),
           multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :date_created_d,
           predicate: ::RDF::URI('https://dbpedia.org/ontology/completionDate'),
           multiple: false do |index|
    index.as :displayable, :stored_searchable
  end

  property :date_issued,
           predicate: ::RDF::URI('http://purl.org/dc/terms/issued'),
           multiple: false do |index|
    index.as :displayable, :stored_searchable
  end

  property :date_issued_d,
           predicate: ::RDF::URI('https://dbpedia.org/ontology/publicationDate'),
           multiple: false do |index|
    index.as :displayable, :stored_searchable
  end

  property :extent,
           predicate: ::RDF::URI('http://rdaregistry.info/Elements/u/P60550'),
           multiple: false do |index|
    index.as :displayable, :stored_searchable
  end

  property :form,
           predicate: ::RDF::URI('http://purl.org/dc/terms/format'),
           multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  property :note,
           predicate: ::RDF::URI('http://www.w3.org/2004/02/skos/core#note'),
           multiple: false do |index|
    index.as :displayable, :stored_searchable
  end

  property :publication_place,
           predicate: ::RDF::URI('https://id.loc.gov/vocabulary/relators/pup'),
           multiple: false do |index|
    index.as :displayable, :stored_searchable
  end

  property :repository,
           predicate: ::RDF::URI('http://id.loc.gov/vocabulary/relators/rps'),
           multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  property :resource_link,
           predicate: ::RDF::Vocab::EDM.isShownAt,
           multiple: false do |index|
    index.as :displayable, :stored_searchable
  end

  property :spatial,
           predicate: ::RDF::URI('http://purl.org/dc/terms/spatial'),
           multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  property :utk_contributor,
           predicate: ::RDF::URI('https://ontology.lib.utk.edu/roles#ctb'),
           multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  property :utk_creator,
           predicate: ::RDF::URI('https://ontology.lib.utk.edu/roles#cre'),
           multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  property :utk_publisher,
           predicate: ::RDF::URI('https://ontology.lib.utk.edu/roles#pbl'),
           multiple: false do |index|
    index.as :displayable, :stored_searchable
  end

  include Hyrax::BasicMetadata
  # The properties below redefine Hyrax::BasicMetadata to specify
  # different property uris. Removing the module causes breaking changes
  property :contributor, predicate: ::RDF::URI('http://id.loc.gov/vocabulary/relators/ctb'),
                         multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  property :creator, predicate: ::RDF::URI('http://id.loc.gov/vocabulary/relators/cre'),
                     multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  property :keyword, predicate: ::RDF::URI('https://w3id.org/idsa/core/keyword'),
                     multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  property :publisher, predicate: ::RDF::URI('http://id.loc.gov/vocabulary/relators/pbl'),
                       multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  property :subject, predicate: ::RDF::URI('http://purl.org/dc/terms/subject'),
                     multiple: true do |index|
    index.as :displayable, :stored_searchable
  end

  self.indexer = CollectionIndexer
  after_update :remove_featured, if: proc { |collection| collection.private? }
  after_destroy :remove_featured

  def remove_featured
    FeaturedCollection.where(collection_id: id).destroy_all
  end
end
