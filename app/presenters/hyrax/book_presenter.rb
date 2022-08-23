# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Book`
module Hyrax
  class BookPresenter < Hyku::WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Book
    delegate(*delegated_properties, to: :solr_document)
  end
end
