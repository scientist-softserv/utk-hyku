module Hyku
  class ManifestEnabledWorkShowPresenter < Hyrax::WorkShowPresenter
    Hyrax::MemberPresenterFactory.file_presenter_class = Hyku::FileSetPresenter

    delegate :extent, :rendering_ids, to: :solr_document

    def manifest_url
      manifest_helper.polymorphic_url([:manifest, self])
    end

    # Hash to populate IIIF manifest with extras. Currently only sequence rendering is implemented.
    #
    # @return [Hash] hash including sequence_rendering
    def manifest_extras
      {
        sequence_rendering: sequence_rendering
      }
    end

    private

      def manifest_helper
        @manifest_helper ||= ManifestHelper.new(request.base_url)
      end

      # IIIF rendering linking property for inclusion in the manifest
      #
      # @return [Array] array of rendering hashes
      def sequence_rendering
        renderings = []
        if solr_document.rendering_ids.present?
          solr_document.rendering_ids.each do |file_set_id|
            renderings << build_rendering(file_set_id)
          end
        end
        renderings.flatten
      end

      # Build a rendering hash
      #
      # @return [Hash] rendering
      def build_rendering(file_set_id)
        query_for_rendering(file_set_id).map do |x|
          label = x['label_ssi'] ? ": #{x.fetch('label_ssi')}" : ''
          {
            '@id' => Hyrax::Engine.routes.url_helpers.download_url(x.fetch(ActiveFedora.id_field), host: request.host),
            'format' => x.fetch('mime_type_ssi') ? x.fetch('mime_type_ssi') : 'unknown mime type',
            'label' => 'Download whole resource' + label
          }
        end
      end

      # Query for the properties to create a rendering
      #
      # @return [SolrResult] query result
      def query_for_rendering(file_set_id)
        ActiveFedora::SolrService.query("id:#{file_set_id}",
                                        fl: [ActiveFedora.id_field, 'label_ssi', 'mime_type_ssi'],
                                        rows: 1)
      end
  end
end
