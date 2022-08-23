# frozen_string_literal: true

module BulkraxMetadata
  extend ActiveSupport::Concern

  included do
    # adding bulkrax_identifier to metadata to make model complient with bulkrax
    property :bulkrax_identifier,
             predicate: ::RDF::URI("https://hykucommons.org/terms/bulkrax_identifier"),
             multiple: false do |index|
      index.as :stored_searchable, :facetable
    end
  end
end
