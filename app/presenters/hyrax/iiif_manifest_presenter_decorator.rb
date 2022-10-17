# frozen_string_literal: true

# OVERRIDE Hyrax 3.4.0 to check the site's ssl_configured when setting protocols
# overriding #display_image to get correct format:
module Hyrax
  module IiifManifestPresenterDecorator
    def search_service
      url = Rails.application.routes.url_helpers.solr_document_url(id, host: hostname)
      Site.account.ssl_configured ? url.sub(/\Ahttp:/, 'https:') : url
    end

    ##
    # @return [Array] the "metadata" field of the manifest with labels from Allinson Flex profile
    #   and values from the Work
    def manifest_metadata
      metadata = labels_and_values.map do |property|
        next unless respond_to?(property.value)
        next unless public_send(property.value)&.present?
        {
          'label' => property.label,
          'value' => Array(send(property.value)).map { |v| scrub(v.to_s) }
        }
      end
      metadata.compact
    end

    ##
    # @return [Array] an array of AllinsonFlex::ProfileProperty objects that hold the labels and values
    #   needed for the manifest metadata
    # @see #manifest_metadata
    def labels_and_values
      # each AR object in this result set will have two attributes, label and value
      @labels_and_values ||= AllinsonFlex::ProfileProperty
                             .find_by_sql(
                               "SELECT DISTINCT allinson_flex_profile_texts.value AS label, " \
                               "allinson_flex_profile_properties.name AS value " \
                               "FROM allinson_flex_profile_properties " \
                               "JOIN allinson_flex_profile_texts " \
                               "ON allinson_flex_profile_properties.id = " \
                                 "allinson_flex_profile_texts.profile_property_id " \
                               "WHERE allinson_flex_profile_texts.name = 'display_label'"
                             )
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
      # overriding to bypass IIIFManifest::V3::ManifestBuilder::CanvasBuilder#display_image
      def display_image; end

      def display_content
        return nil unless model.image?
        return nil unless latest_file_id

        IIIFManifest::V3::DisplayContent
          .new(display_image_url(hostname),
               format: object.mime_type,
               width: width,
               height: height,
               type: 'Image',
               iiif_endpoint: iiif_endpoint(latest_file_id, base_url: hostname))
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
