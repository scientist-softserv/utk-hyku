# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  class GenericWorkPresenter < Hyku::WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::GenericWork
    delegate(*delegated_properties, to: :solr_document)
  end
end
