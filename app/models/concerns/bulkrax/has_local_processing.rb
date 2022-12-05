# frozen_string_literal: true

module Bulkrax
  module HasLocalProcessing
    include ControlledIndexerBehavior

    # SOURCES_OF_AUTHORITIES = {
    #   # local db, faster
    #   ::Qa::Authorities::Local => 'local',
    #   # remote, slower
    #   ::Qa::Authorities::Loc => 'loc',
    #   ::Qa::Authorities::Getty => 'getty'
    # }.freeze

    def add_local
      add_controlled_fields
    end

    private 

    # Controlled fields expect an ActiveTriples instance as a value. Bulkrax only imports strings.
    # Use the imported string values to lookup or create valid ActiveTriples URIs and add them
    # to the Entry's parsed_metadata in the format that the actor stack expects.
    def add_controlled_fields
      controlled_field_names.each do |field_name|
      # metadata_schema.controlled_field_names.each do |field_name|
        field = field_name
        # field = get_field(field_name)
        # field = metadata_schema.get_field(field_name)
        raw_metadata_for_field = raw_metadata.select { |k, _v| k.match?(/#{field_name.downcase}(_\d+)?/) }
        next if raw_metadata_for_field.blank?

        all_values = raw_metadata_for_field.values.compact&.map { |value| value.split(/\s*[|]\s*/) }&.flatten
        parsed_metadata[field_name] = []
        next if all_values.blank?

        # parsed_metadata.delete(field_name) # replacing field_name with field_name_attributes
        all_values.each_with_index do |value, i|
          auth_id = sanitize_controlled_field_uri(value) # assume user-provided URI references a valid authority
          # fetch and cache authority (job) => background job to go to LOC and pull them into local db. Authority.fetch_cache_term
          # auth_id ||= search_authorities_for_id(field, value)
          # auth_id ||= create_local_authority_id(field, value)
          next unless auth_id.present?

          parsed_metadata["#{field_name}"] ||= {}
          parsed_metadata["#{field_name}"][i] = auth_id
          #  Error: ActiveTriples::Relation::ValueError - value must be an RDF URI, Node, Literal, or a valid datatype. See RDF::Literal. You provided {0=>{"id"=>"http://id.loc.gov/authorities/subjects/sh85001932"}, 1=>{"id"=>"http://id.loc.gov/vocabulary/graphicMaterials/tgm008083"}, 2=>{"id"=>"http://id.loc.gov/vocabulary/graphicMaterials/tgm006438"}}
          # parsed_metadata["#{field_name}"][i] = { 'id' => auth_id }
        end
      end
    end

    # @return [String, nil] URI for authority, or nil if one could not be found
    def search_authorities_for_id(field, value)
      found_id = nil

      SOURCES_OF_AUTHORITIES.each do |auth_source, auth_name|
        subauth_name = get_subauthority_for(field: field, authority_name: auth_name)
        next unless subauth_name.present?

        subauthority = auth_source.subauthority_for(subauth_name)
        results = subauthority.search(value)

        results.each do |result|
          found_id = result['id'] if result['label'].parameterize == value.parameterize
        end
      end

      found_id
    end

    # @return [String, nil] URI for local authority, or nil if one could not be created
    def create_local_authority_id(field, value)
      local_subauth_name = get_subauthority_for(field: field, authority_name: 'local')
      mint_local_auth_url(local_subauth_name, value) if local_subauth_name.present?
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
