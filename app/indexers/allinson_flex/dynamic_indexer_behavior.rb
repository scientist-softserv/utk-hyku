# frozen_string_literal: true

# OVERRIDE AllinsonFlex v0.1.0 to turn URI's into human readable strings
#
# For whatever reason our decorator pattern was not overriding #generate_solr_document
# If you check AllinsonFlex::DynamicIndexerBehavior.ancestors, you get what you expect
# with a decorator.  If you checked the #source_location of :generate_solr_document
# you also get what you expect.  However, when running a reindex, I was not going
# through the decorator.  I decided since this is only one method, overriding the entire
# mixin was acceptable for now.

module AllinsonFlex
  module DynamicIndexerBehavior
    include UriToStringBehavior
    extend ActiveSupport::Concern

    RANGE = "http://www.w3.org/2001/XMLSchema#anyURI"

    included do
      class_attribute :model_class
    end

    def generate_solr_document
      dynamic_schema_service = object.dynamic_schema_service
      uri_properties = uri_properties_from(dynamic_schema_service)

      super.tap do |solr_doc|
        dynamic_schema_service.indexing_properties.each_pair do |prop_name, index_field_names|
          value = if uri_properties.include?(prop_name.to_s)
                    uri_to_value_for(object.send(prop_name))
                  else
                    object.send(prop_name)
                  end

          index_field_names.each { |index_field_name| solr_doc[index_field_name] = value }
        end
      end
    end

    private

      def uri_properties_from(dynamic_schema_service)
        schema = HashWithIndifferentAccess.new(dynamic_schema_service.dynamic_schema.schema)
        props_hash = schema[:properties]
        # remove rdf_type since they are also URIs but not for our purposes
        props_hash.keys.select { |k, _v| props_hash[k][:range] == RANGE } - local_authorities - ['rdf_type']
      end

      def local_authorities
        # Hyku has these pluralized while m3 has these singularized
        Qa::Authorities::Local.names.map(&:singularize)
      end
  end
end
