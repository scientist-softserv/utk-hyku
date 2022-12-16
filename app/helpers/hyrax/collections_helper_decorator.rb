# frozen_string_literal: true

module Hyrax
  # Decorator for Hyrax 3.4.2
  # Adding custom helper to return work count in a specific collection

  module CollectionsHelperDecorator
    def works_count_for(collection:)
      ActiveFedora::SolrService.query("member_of_collection_ids_ssim:#{collection.id}").count
    end
  end
end
