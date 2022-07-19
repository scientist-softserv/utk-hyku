# frozen_string_literal: true

class GenericWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  property :bulkrax_identifier,
           predicate: ::RDF::URI("https://hykucommons.org/terms/bulkrax_identifier"),
           multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  include AllinsonFlex::DynamicMetadataBehavior
  include ::Hyrax::BasicMetadata

  validates :title, presence: { message: 'Your work must have a title.' }

  self.indexer = GenericWorkIndexer
end
