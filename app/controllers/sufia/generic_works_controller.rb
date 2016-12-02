require 'iiif_manifest'
module Sufia
  class GenericWorksController < ApplicationController
    include Sufia::CurationConcernController
    # Adds Sufia behaviors to the controller.
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = GenericWork
    self.show_presenter = Sufia::GenericWorkShowPresenter

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
