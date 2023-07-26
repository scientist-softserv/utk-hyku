# frozen_string_literal: true

module OAI
  module Provider
    module MetadataFormat
      class Mods < OAI::Provider::Metadata::Format
        def initialize
          @prefix = 'mods'
          @schema = 'https://www.loc.gov/standards/mods/v3/mods-3-5.xsd'
          @namespace = 'http://www.loc.gov/mods/v3'
          @element_namespace = 'mods'

          # Fields are set in the mods_solr_document concern rather than using @fields.
          # Because of this, no model_decorator to define map_mods is needed.
        end

        # Override to strip namespace and header out
        def encode(_model, record)
          record.to_oai_mods
        end

        def header_specification
          {
          }
        end
      end
    end
  end
end

OAI::Provider::Base.register_format(OAI::Provider::MetadataFormat::Mods.instance)
