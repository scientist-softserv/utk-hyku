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
