# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyku::WorkShowPresenter
    # We do not use this generated ImagePresenter. Instead we use the
    # WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Image
    delegate(*delegated_properties, to: :solr_document)
  end
end
