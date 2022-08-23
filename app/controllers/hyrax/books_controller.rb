# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Book`
module Hyrax
  # Generated controller for Book
  class BooksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include AllinsonFlex::DynamicControllerBehavior
    self.curation_concern_type = ::Book

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::BookPresenter
  end
end
