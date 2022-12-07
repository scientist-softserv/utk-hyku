# frozen_string_literal: true

module Authority
  extend ActiveSupport::Concern

  class_methods do
    # fetch and cache authority (job) => background job to go to LOC and pull them into local db. Authority.fetch_cache_term
    def fetch_cache_term(url)


    end

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

      binding.pry
    end

    # make factory pattern/single point of entry for the term - pass URL and get back relevant label. This will also make it easier to test
    # make RemoteAuthority module . Authority.label_for_url(url) -  check for where url is (local, db, remote)
    def label_for_url(url)
# LdBuffer.fetch(uri) do QA.authority_for_url.find
# if not there, call remote finder and store the label (ref: active support cache store)
# cache by hand is error prone due to asynchronicity so create a ticket to implement with active support to avoid collisions
# Jeremy is working on wrapper for QA
request_header = {:subauthority => "subjects"}
authority = Qa::Authorities::LinkedData::GenericAuthority.new(:LOC)
authority.find('sh85001932', request_header: request_header)


      # auth = Qa::Authorities::Loc.subauthority_for("subjects").find("sh85076841")
      # => [{"@id"=>"http://id.loc.gov/resources/works/11248988", "@type"=>["http://id.loc.gov/ontologies/bibframe/Work"...
      QA.authority_for()
      Rails.logger.info "Adding buffer entry - label: #{label}, url:  #{url.to_s}"
      LdBuffer.create(url: url, label: label)

      # Delete oldest records if we have more than 5K in the buffer
      if (cnt = LdBuffer.count - 5000) > 0
        ids = LdBuffer.order('created_at ASC').limit(cnt).pluck(:id)
        LdBuffer.where(id: ids).delete_all
      end
    end

    # will allow us to make submodules for each type (ie: geoname)
    # local caching can be done at the remoteAuthority level.
    # this separates frontend from backend. someone can handle frontend. someone else can handle adding more sub authorities.
    # with the argument passed we need to figure out where authority is (ask remote, db cache or local)
    # Break tickets down
    # UI/Indexing (label show on page (solr), editing should show label(fedora) )
    # BACKEND How is this done in questioning authority (remote interaction). get authority module working to return a string once passed a url
    # Insullation layer (=> create wrapper around calling gem directly. can help to protect us from being codependent on the gem)
    # do we can the label to be saved in fedora? 
  end
end