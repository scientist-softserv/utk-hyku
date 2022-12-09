# frozen_string_literal: true

module Bulkrax
  module HasLocalProcessing
    include ControlledIndexerBehavior
    include Authority

    AuthorityInfo = Struct.new(:authority, :subauthority, :id, :uri, keyword_init: true)

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
          next unless auth_id.present?

          info = extract_authority_info_from(auth_id)
          label = fetch_remote_label(info)
          cache_label(info.uri, label)

          parsed_metadata["#{field_name}"] ||= {}
          # fetch and cache authority (job) => background job to go to LOC and pull them into local db. Authority.fetch_cache_term
          # parsed_metadata["#{field_name}"][i] = ::AppIndexer.fetch_remote_label(auth_id)
          # binding.pry if field_name == 'subject'

          parsed_metadata["#{field_name}"][i] = fetch_remote_label(info)
        end
      end
    end

    def sanitize_controlled_field_uri(value)
      return unless value.match?(::URI::DEFAULT_PARSER.make_regexp)

      valid_value = value.strip.chomp.sub('https', 'http')
      valid_value.chop! if valid_value.match?(%r{/$}) # remove trailing forward slash if one is present

      valid_value
    end

    def extract_authority_info_from(url)
      uri = URI.parse(url)
      domain = uri.host.downcase # should this come from the metadata profile?
      authority = :LOC if domain.include?("loc") # focus on implementing LOC first
      # authority = get_field(field_name)
      subauthority = uri.path.split('/').third # => ["", "authorities", "subjects", "sh85001932"]
      uri_id = uri.path.split('/').last 
      AuthorityInfo.new(authority: authority, subauthority: subauthority, id: uri_id, uri: url)
    end

    def fetch_remote_label(info)
      if info.uri.is_a? ActiveTriples::Resource
        resource = info.uri
        url = resource.id.dup
      end
      # if it's buffered, return the buffer
      if (buffer = LdBuffer.find_by(url: url))
        if (Time.now - buffer.updated_at).seconds > 1.year
          LdBuffer.where(url: url).each{|buffer| buffer.destroy }
        else
          return buffer.label
        end
      end

      begin
        request_header = {:subauthority => info.subauthority}
        context = Qa::AuthorityRequestContext.new(subauthority: info.subauthority, headers: request_header)
        authority = Qa.authority_for(vocab: info.authority, subauthority: info.subauthority, context: context)
        # authority = Qa::Authorities::LinkedData::GenericAuthority.new(info.authority) # how to get auth?
        # label = authority.find(info.id, request_header: request_header)[:label]
        return authority.find(info.id)[:label].join
      rescue Exception => e
        # IOError could result from a 500 error on the remote server
        # SocketError results if there is no server to connect to
        Rails.logger.error "Unable to fetch #{url} from the authorative source.\n#{e.message}"
        return info.uri
      end
    end

    def cache_label(url, label)
      Rails.logger.info "Adding buffer entry - label: #{label}, url:  #{url.to_s}"
      LdBuffer.create(url: url, label: label)

      # Delete oldest records if we have more than 5K in the buffer
      if (cnt = LdBuffer.count - 5000) > 0
        ids = LdBuffer.order('created_at ASC').limit(cnt).pluck(:id)
        LdBuffer.where(id: ids).delete_all
      end
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
