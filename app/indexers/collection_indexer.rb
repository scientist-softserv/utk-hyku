# frozen_string_literal: true
require 'nokogiri'
require 'open-uri'
require 'linkeddata'
class CollectionIndexer < Hyrax::CollectionIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata
  # This contains all the custom code for indexing controlled vocabulary fields
  include ControlledIndexerBehavior
  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["bulkrax_identifier_sim"] = object.bulkrax_identifier
      solr_doc["account_cname_tesim"] = Site.instance&.account&.cname
      solr_doc = index_controlled_fields(solr_doc)
    end
  end
end
