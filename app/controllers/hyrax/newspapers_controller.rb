# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Newspaper`
module Hyrax
  # Generated controller for Newspaper
  class NewspapersController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include AllinsonFlex::DynamicControllerBehavior
    self.curation_concern_type = ::Newspaper

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::NewspaperPresenter
  end
end
