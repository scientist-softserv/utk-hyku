# Generated via
#  `rails generate curation_concerns:work Image`

module Sufia
  class ImagesController < ApplicationController
    include Sufia::CurationConcernController
    # Adds Sufia behaviors to the controller.
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = Image
  end
end
