# Generated via
#  `rails generate curation_concerns:work Image`

module Hyrax
  class ImagesController < ApplicationController
    include Hyrax::CurationConcernController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior

    self.curation_concern_type = Image
  end
end
