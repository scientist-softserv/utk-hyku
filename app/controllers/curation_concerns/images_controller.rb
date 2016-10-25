# Generated via
#  `rails generate curation_concerns:work Image`

module CurationConcerns
  class ImagesController < ApplicationController
    include CurationConcerns::CurationConcernController
    # Adds Sufia behaviors to the controller.
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = Image
  end
end
