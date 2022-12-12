# frozen_string_literal: true
require 'nokogiri'
require 'open-uri'
require 'linkeddata'
class AppIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  # include Hyrax::IndexesBasicMetadata
  include ControlledIndexerBehavior

  # Fetch remote labels for objects with controlled properties (i.e. :based_near)
  # Utk does not include based_near and does not need deep indexing.
  # include Hyrax::IndexesLinkedMetadata

  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["account_cname_tesim"] = Site.instance&.account&.cname
      # the method 'index_controlled_fields' is defined in controlled_indexer_behavior.rb
      # It resolves metadata URLS from externally controlled vocabularies and indexes the associated labels
      solr_doc = index_controlled_fields(solr_doc)
    end
  end
end
