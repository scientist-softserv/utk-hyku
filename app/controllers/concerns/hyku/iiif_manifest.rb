module Hyku
  # A controller mixin that provides a manifest action, which returns a
  # IIIF manifest for the presentation API
  module IIIFManifest
    extend ActiveSupport::Concern

    included do
      self.show_presenter = Hyku::ManifestEnabledWorkShowPresenter

      skip_load_and_authorize_resource only: :manifest
    end

    def manifest
      headers['Access-Control-Allow-Origin'] = '*'
      respond_to do |format|
        format.json { render json: manifest_builder.to_h }
      end
    end

    private

      def manifest_builder
        ::IIIFManifest::ManifestFactory.new(presenter)
      end
  end
end
