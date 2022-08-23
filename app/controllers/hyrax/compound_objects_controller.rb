# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work CompoundObject`
module Hyrax
  # Generated controller for CompoundObject
  class CompoundObjectsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include AllinsonFlex::DynamicControllerBehavior
    self.curation_concern_type = ::CompoundObject

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::CompoundObjectPresenter
  end
end
