module Hyrax
  class GenericWorksController < ApplicationController
    include Hyrax::CurationConcernController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior

    self.curation_concern_type = GenericWork

    include Hyku::IIIFManifest
  end
end
