# frozen_string_literal: true

module Hyrax
  module FileSetIndexerDecorator
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc['rdf_type_ssim'] = object.rdf_type
      end
    end
  end
end

Hyrax::FileSetIndexer.prepend(Hyrax::FileSetIndexerDecorator)
