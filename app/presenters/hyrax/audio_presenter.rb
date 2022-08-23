# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Audio`
module Hyrax
  class AudioPresenter < Hyku::WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Audio
    delegate(*delegated_properties, to: :solr_document)
  end
end
