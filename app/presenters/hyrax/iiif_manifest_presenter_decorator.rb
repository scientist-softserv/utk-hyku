# frozen_string_literal: true

# OVERRIDE Hyrax 3.4.0 to check the site's ssl_configured when setting protocols
# overriding #display_image to get correct format:
module Hyrax
  module IiifManifestPresenterDecorator
    attr_writer :iiif_version

    def iiif_version
      @iiif_version || 3
    end

    def search_service
      url = Rails.application.routes.url_helpers.solr_document_iiif_search_url(id, host: hostname)
      Site.account.ssl_configured ? url.sub(/\Ahttp:/, 'https:') : url
    end

    ##
    # @return [String] the URL where the manifest can be found
    def manifest_url
      return '' if id.blank?

      protocol = Site.account.ssl_configured ? 'https' : 'http'
      Rails.application.routes.url_helpers.polymorphic_url([:manifest, model], host: hostname, protocol: protocol)
    end

    ##
    # @return [String] the URL that is used in the manifest to link back to the show page
    # @see ManifestBuilderServiceDecorator#homepage
    def work_url
      protocol = Site.account.ssl_configured ? 'https' : 'http'
      Rails.application.routes.url_helpers.polymorphic_url(model, host: hostname, protocol: protocol)
    end

    # TODO: MAY BE A TEMPORARY IMPLEMENTATION UNTIL #is_part_of IS SET UP
    ##
    # @return [String] the URL to the Work's Collection show page
    def collection_url(collection_id)
      return '' if collection_id.blank?

      protocol = Site.account.ssl_configured ? 'https' : 'http'
      "#{protocol}://#{hostname}/collections/#{collection_id}"
    end

    module DisplayImagePresenterDecorator
      # overriding to include #display_content from the hyrax-iiif_av gem
      def display_image; end
      include Hyrax::IiifAv::DisplaysContent

      # override Hyrax to keep pdfs from gumming up the v3 manifest
      # in app/presenters/hyrax/iiif_manifest_presenter.rb
      def file_set?
        super && (image? || audio? || video?) && intermediate_file?
      end

      # OVERRIDE Hyrax 3.5.0 to use #supplementing_content for IIIF Manifest v1.3.1
      def supplementing_content
        @supplementing_content ||= begin
          return [] unless media_and_transcript?

          attachments = transcript_attachments
          attachments.map do |attachment|
            create_supplementing_content(attachment)
          end
        end
      end

      private

        TRANSCRIPT_RDF_TYPE = "http://pcdm.org/use#Transcript"

        def media_and_transcript?
          (audio? || video?) && transcript_attachments.present?
        end

        def transcript_attachments
          parent = ::FileSet.find(id).parent.member_of.first
          return [] unless parent

          parent.members.select { |member| member.rdf_type == [TRANSCRIPT_RDF_TYPE] }
        end

        def create_supplementing_content(attachment)
          hash = get_file_set_ids_and_languages(attachment)
          captions_url = get_captions_url(hash[:file_set_id])
          IIIFManifest::V3::SupplementingContent.new(captions_url,
                                                     type: 'text',
                                                     format: 'text/vtt',
                                                     label: hash[:title],
                                                     language: hash[:language].first || 'en')
        end

        def get_file_set_ids_and_languages(attachment)
          {
            file_set_id: attachment.file_sets.first.id,
            title: attachment.title.first,
            language: attachment.file_language
          }
        end

        def get_captions_url(file_set_id)
          captions_url = Hyrax::Engine.routes.url_helpers.download_url(file_set_id, host: hostname)
          ssl_configured = Site.account.ssl_configured
          ssl_configured ? captions_url.sub!(/\Ahttp:/, 'https:') : captions_url
        end
    end

    private

      def scrub(value)
        CGI.unescapeHTML(Loofah.fragment(value).scrub!(:whitewash).to_s)
      end
  end
end

Hyrax::IiifManifestPresenter.prepend(Hyrax::IiifManifestPresenterDecorator)
Hyrax::IiifManifestPresenter::DisplayImagePresenter
  .prepend(Hyrax::IiifManifestPresenterDecorator::DisplayImagePresenterDecorator)
