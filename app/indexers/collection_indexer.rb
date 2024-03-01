# frozen_string_literal: true

class CollectionIndexer < Hyrax::CollectionIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata
  include UriToStringBehavior

  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["creator_sim"] = solr_doc["creator_tesim"] = all_creators
      solr_doc["bulkrax_identifier_sim"] = object.bulkrax_identifier
      solr_doc["account_cname_tesim"] = Site.instance&.account&.cname
      solr_doc[CatalogController.title_field] = object.title.first
    end
  end

  private

    def all_creators
      SolrDocument.creator_fields.map { |prop| uri_to_value_for(object.try(prop)) }.flatten.compact
    end
end
