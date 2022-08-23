# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Audio`
module Hyrax
  # Generated controller for Audio
  class AudiosController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include AllinsonFlex::DynamicControllerBehavior
    self.curation_concern_type = ::Audio

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::AudioPresenter
  end
end
