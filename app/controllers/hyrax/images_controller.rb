module Hyrax
  class ImagesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks

    self.curation_concern_type = Image

    include Hyku::IIIFManifest
  end
end
