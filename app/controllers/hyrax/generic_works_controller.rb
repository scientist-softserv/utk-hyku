module Hyrax
  class GenericWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks

    self.curation_concern_type = GenericWork

    include Hyku::IIIFManifest
  end
end
