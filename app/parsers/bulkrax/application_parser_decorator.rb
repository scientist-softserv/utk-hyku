# frozen_string_literal: true

module Bulkrax
  module ApplicationParserDecorator
    def work_identifier_search_field
      @work_identifier_search_field ||= Array.wrap(get_field_mapping_hash_for('source_identifier')
                                                     &.values
                                                     &.first
                                                     &.[]('search_field'))&.first&.to_s || "#{work_identifier}_sim"
    end
  end
end

Bulkrax::ApplicationParser.prepend(Bulkrax::ApplicationParserDecorator)
