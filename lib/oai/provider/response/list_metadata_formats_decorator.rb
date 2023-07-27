# frozen_string_literal: true

module OAI
  module Provider
    module Response
      module ListMetadataFormatsDecorator
        def record_supports(record, prefix)
          prefix == 'oai_dc' ||
            prefix == 'mods' ||
            record.respond_to?("to_#{prefix}") ||
            record.respond_to?("map_#{prefix}")
        end
      end
    end
  end
end

OAI::Provider::Response::ListMetadataFormats.prepend(OAI::Provider::Response::ListMetadataFormatsDecorator)
