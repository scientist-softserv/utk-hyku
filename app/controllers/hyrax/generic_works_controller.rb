require 'iiif_manifest'
module Hyrax
  class GenericWorksController < ApplicationController
    include Hyrax::CurationConcernController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior

    self.curation_concern_type = GenericWork
    self.show_presenter = Hyrax::GenericWorkShowPresenter

    skip_load_and_authorize_resource only: :manifest

    def manifest
      headers['Access-Control-Allow-Origin'] = '*'
      respond_to do |format|
        format.json { render json: manifest_builder.to_h }
      end
    end

    private

      def manifest_builder
        IIIFManifest::ManifestFactory.new(presenter)
      end
  end
end
