# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work CompoundObject`
module Hyrax
  class CompoundObjectPresenter < Hyku::WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::CompoundObject
    delegate(*delegated_properties, to: :solr_document)
  end
end
