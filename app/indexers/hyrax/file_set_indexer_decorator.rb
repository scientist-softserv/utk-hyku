# frozen_string_literal: true

# OVERRIDE Hyrax v3.5.0 to index the rdf_type on the FileSet

module Hyrax
  module FileSetIndexerDecorator
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc['rdf_type_ssim'] = object.parent_works.first.rdf_type if attachment?
        solr_doc['all_text_tesimv'] = solr_doc['all_text_tsimv'] if solr_doc['all_text_tsimv'].present?
      end
    end

    private

      def attachment?
        object.parent_works.first.is_a?(Attachment)
      end
  end
end

Hyrax::FileSetIndexer.prepend(Hyrax::FileSetIndexerDecorator)
