# frozen_string_literal: true

# OVERRIDE BULKRAX 4.4.0 to remove resource_type from #process_parse
# this app redefined resouce_types.yml to be inline with local questioning
# authority

# OVERRIDE BULKRAX 7.0.0 to return early if the subject is a URI
module Bulkrax
  module ApplicationMatcherDecorator
    def process_parse
      # New parse methods will need to be added here
      # OVERRIDE BULKRAX 4.4.0 to remove resource_type from parsed_fields variable
      parsed_fields = ['remote_files', 'language', 'subject', 'types', 'model', 'format_original']
      # This accounts for prefixed matchers
      parser = parsed_fields.find { |field| to&.include? field }
      if @result.is_a?(Array) && parsed && respond_to?("parse_#{parser}")
        @result.each_with_index do |res, index|
          @result[index] = send("parse_#{parser}", res.strip)
        end
        @result.delete(nil)
      elsif parsed && respond_to?("parse_#{parser}")
        @result = send("parse_#{parser}", @result)
      end
    end

    def parse_subject(src)
      # OVERRIDE: we don't want to capitalize URIs
      return src if src.starts_with?('http')

      super
    end
  end
end

Bulkrax::ApplicationMatcher.prepend(Bulkrax::ApplicationMatcherDecorator)
