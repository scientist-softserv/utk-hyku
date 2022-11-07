# frozen_string_literal: true

class AppIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  # include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for objects with controlled properties (i.e. :based_near)
  # Utk does not include based_near and does not need deep indexing.
  # include Hyrax::IndexesLinkedMetadata

  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["account_cname_tesim"] = Site.instance&.account&.cname
    end
  end
end
