# frozen_string_literal: true

class CollectionIndexer < Hyrax::CollectionIndexer
  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["bulkrax_identifier_sim"] = object.bulkrax_identifier
      solr_doc["account_cname_tesim"] = Site.instance&.account&.cname
    end
  end
end
