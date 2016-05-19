require 'iiif_manifest'
module CurationConcerns
  class GenericWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
    # Adds Sufia behaviors to the controller.
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = GenericWork
    self.show_presenter = CurationConcerns::GenericWorkShowPresenter

    skip_load_and_authorize_resource only: :manifest

    def manifest
      headers['Access-Control-Allow-Origin'] = '*'
      respond_to do |format|
        format.json { render json: manifest_builder.to_h }
      end
    end

    protected

      # Overrideing to pass in a third argument, the hostname. Used for IIIF manifest
      def presenter
        @presenter ||= show_presenter.new(curation_concern_from_search_results, current_ability, request.base_url)
      end

    private

      def manifest_builder
        IIIFManifest::ManifestFactory.new(presenter)
      end
  end
end
