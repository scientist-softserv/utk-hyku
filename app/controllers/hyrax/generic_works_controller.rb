# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  # Generated controller for GenericWork
  class GenericWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include AllinsonFlex::DynamicControllerBehavior
    self.curation_concern_type = ::GenericWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::GenericWorkPresenter
  end
end
