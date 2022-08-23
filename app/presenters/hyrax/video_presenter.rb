# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Video`
module Hyrax
  class VideoPresenter < Hyku::WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Video
    delegate(*delegated_properties, to: :solr_document)
  end
end
