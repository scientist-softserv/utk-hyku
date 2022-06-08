# frozen_string_literal: true

# Generated by hyrax:models:install
class FileSet < ActiveFedora::Base
  property :bulkrax_identifier,
           predicate: ::RDF::URI("https://hykucommons.org/terms/bulkrax_identifier"),
           multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  include ::Hyrax::FileSetBehavior
end
