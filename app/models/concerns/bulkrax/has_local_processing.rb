# frozen_string_literal: true

module Bulkrax
  module HasLocalProcessing
    include ControlledIndexerBehavior

    def add_local
      add_controlled_fields
    end

    private 

    # Controlled fields expect an ActiveTriples instance as a value. Bulkrax only imports strings.
    # Use the imported string values to lookup or create valid ActiveTriples URIs and add them
    # to the Entry's parsed_metadata in the format that the actor stack expects.
    def add_controlled_fields
      controlled_field_names.each do |field_name|
        raw_metadata_for_field = raw_metadata.select { |k, _v| k.match?(/#{field_name.downcase}(_\d+)?/) }
        next if raw_metadata_for_field.blank?

        all_values = raw_metadata_for_field.values.compact&.map { |value| value.split(/\s*[|]\s*/) }&.flatten
        parsed_metadata[field_name] = []
        next if all_values.blank?

        # parsed_metadata.delete(field_name) # replacing field_name with field_name_attributes
        all_values.each_with_index do |value, i|
          auth_id = sanitize_controlled_field_uri(value) # assume user-provided URI references a valid authority
          # fetch and cache authority (job) => background job to go to LOC and pull them into local db. Authority.fetch_cache_term
          next unless auth_id.present?

          parsed_metadata["#{field_name}"] ||= {}
          parsed_metadata["#{field_name}"][i] = ::AppIndexer.fetch_remote_label(auth_id)
        end
      end
    end

    def sanitize_controlled_field_uri(value)
      return unless value.match?(::URI::DEFAULT_PARSER.make_regexp)

      valid_value = value.strip.chomp.sub('https', 'http')
      valid_value.chop! if valid_value.match?(%r{/$}) # remove trailing forward slash if one is present

      valid_value
    end

    def metadata_schema
      AllinsonFlex::DynamicSchema.last
    end

    def controlled_field_names
      @controlled_vocabulary_properties ||= []
      metadata_schema.schema['properties'].each do |key, value|
        @controlled_vocabulary_properties << key if value["controlled_values"] != ["null"]
      end
      @controlled_vocabulary_properties
    end

    def get_field(field_name)
      metadata_schema.schema['properties'][field_name]
    end
  end
end
