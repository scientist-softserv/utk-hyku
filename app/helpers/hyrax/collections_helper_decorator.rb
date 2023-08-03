# frozen_string_literal: true

module Hyrax
  # Decorator for Hyrax 3.4.2
  # Adding custom helper to return work count in a specific collection

  module CollectionsHelperDecorator
    def works_count_for(collection:)
      ActiveFedora::SolrService.query("member_of_collection_ids_ssim:#{collection.id}").count
    end

    def collections_show?
      controller_name == 'collections' && action_name == 'show'
    end

    METADATA_FOR_SHOW_PAGE = %i[abstract creator date_created date_issued keyword local_creator subject].freeze

    def metadata_fields_for_show_page(presenter_terms_with_values)
      presenter_terms_with_values.select { |field_name| METADATA_FOR_SHOW_PAGE.include?(field_name) }
    end
  end
end
