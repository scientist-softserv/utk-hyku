module ControlledIndexerBehavior
  extend ActiveSupport::Concern


  class_methods do

    def fetch_remote_label(url)
      if url.is_a? ActiveTriples::Resource
        resource = url
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
      binding.pry
        # handle local qa table based vocabs
      if url.to_s.include?("http://localhost")
      # if url.to_s.include?("ucsc.edu") or url.to_s.include?("http://localhost")
        #url.gsub!('http://','https://') if url.to_s.include? "library.ucsc.edu"
        label = JSON.parse(Net::HTTP.get_response(URI(url)).body)["label"]
      # handle geonames specially
      elsif url.include? "geonames.org"
        # make sure we fetch the rdf record, not the normal html one
        if (res_url = url.dup) =~ /geonames.org\/[0-9]+.*\z/ && !res_url.include?("/about.rdf")
          res_url = url.gsub(/(geonames.org\/[0-9]+).*\z/,"\\1/about.rdf")
        end
        # Interpret the xml result ourselves
        doc = Nokogiri::XML(open(res_url))
        label = doc.xpath('//gn:name').first.children.first.text.dup
      # fetch from other normal authorities
      else
        # Smoothly handle some common syntax issues
        cleaned_url = url.dup
        if url.include?("vocab.getty.edu") # make factory pattern/single point of entry for the term - pass URL and get back relevant label. This will also make it easier to test
          # make RemoteAuthority module . Authority.label_for_url(url) -  check for where url is (local, db, remote)
          # will allow us to make submodules for each type (ie: geoname)
          # local caching can be done at the remoteAuthority level.
          # this separates frontend from backend. someone can handle frontend. someone else can handle adding more sub authorities.
          # with the argument passed we need to figure out where authority is (ask remote, db cache or local)
          # Break tickets down
          # UI/Indexing (label show on page (solr), editing should show label(fedora) )
          # BACKEND How is this done in questioning authority (remote interaction). get authority module working to return a string once passed a url
          # Insullation layer (=> create wrapper around calling gem directly. can help to protect us from being codependent on the gem)
          # do we can the label to be saved in fedora? 


          cleaned_url.gsub!("/page/","/")
          cleaned_url.gsub!('http://','https://')
          response = Net::HTTP.get_response(URI(cleaned_url))
          res = Nokogiri::HTML.parse(response.body)
          label = res.title.strip
        elsif !cleaned_url.is_a? String
          resource = ActiveTriples::Resource.new(cleaned_url)
          labels = resource.fetch(headers: { 'Accept'.freeze => default_accept_header }).rdf_label
          if labels.count == 1
            label = labels.first.dup.to_s
          else
            label = labels.find{|label| label.language.to_s =~ /en/ }.dup.to_s
          end
        else
          label = cleaned_url
        end
      end
      if label == url && (url.include?("id.loc.gov") || url.include?("info:lc"))
        url = url.gsub("info:lc","http://id.loc.gov")
        url = url.gsub('http://','https://')
        request_url = URI("#{url}.html")
        request_url.path += '.html'
        response = Net::HTTP.get_response(request_url)
        res = Nokogiri::HTML.parse(response.body)
        label = res.title.split('-')[0].strip
      end
      Rails.logger.info "Adding buffer entry - label: #{label}, url:  #{url.to_s}"
      LdBuffer.create(url: url, label: label)

      # Delete oldest records if we have more than 5K in the buffer
      if (cnt = LdBuffer.count - 5000) > 0
        ids = LdBuffer.order('created_at ASC').limit(cnt).pluck(:id)
        LdBuffer.where(id: ids).delete_all
      end
      raise Exception if label.to_s == url.to_s

      return label.to_s

      rescue Exception => e
        # IOError could result from a 500 error on the remote server
        # SocketError results if there is no server to connect to
         Rails.logger.error "Unable to fetch #{url} from the authorative source.\n#{e.message}"
         return false
      end
    end

    private

    def destroy_buffer(url)
      LdBuffer.where(url: url).each{|buffer| buffer.destroy }
    end
    
    def default_accept_header
      RDF::Util::File::HttpAdapter.default_accept_header.sub(/, \*\/\*;q=0\.1\Z/, '')
    end

  end

  def index_controlled_fields(solr_doc)
    return solr_doc unless object.persisted?
    # schema.controlled_field_names.each do |field_name|
    controlled_field_names.each do |field_name|
      # field = get_field(field_name)
      # field = schema.get_field(field_name)

      # Clear old values from the solr document
      solr_doc.delete "#{field_name}_tesim"
      # solr_doc.delete Solrizer.solr_name(field_name)
      solr_doc.delete "#{field_name}_ssm"
      # solr_doc.delete Solrizer.solr_name(field_name.to_sym)
      # field.solr_names.each do |solr_name| 
      #   solr_doc.delete(solr_name)
      #   solr_doc.delete(solr_name.to_sym)
      # end

      # Wrap single objects in arrays if necessary (though it shouldn't be)
      #      object[field_name] = Array.wrap(object[field_name])

      # Loop through the different values provided for this property
      next unless object.attribute_names.include?(field_name)
      next unless object[field_name].present?
      values = []
      object[field_name].each do |val|
        label = ""
        case val
        when ActiveTriples::Resource, URI::regexp
          # We need to fetch the string from an external vocabulary
          label = ::AppIndexer.fetch_remote_label(val)
          # skip indexing this one if we can't retrieve the label
          next unless label
        when String
          # This is just a normal string (from a legacy model, etc)
          # Go ahead and create a new entry in the appropriate local vocab, if there is one
          # subauth_name = get_subauthority_for(field: field_name, authority_name: 'local')
          # next unless subauth_name.present? # If have a random string and no local vocab, just move on for now

          # mint_local_auth_url(field_name, val)
          # mint_local_auth_url(subauth_name, val) if subauth_name.present?
          label = val
        else
          raise ArgumentError, "Can't handle #{val.class} as a metadata term"
        end

        # values << label
        (solr_doc["#{field_name}_tesim"] ||= []) << label
        (solr_doc["#{field_name}_ssm"] ||= []) << label
        # field.solr_names.each do |solr_name| 
        #   (solr_doc[solr_name] ||= []) << label
        # end
      end
      # solr_doc.update({"#{field_name}_tesim" => values})
    end
    solr_doc
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
end
