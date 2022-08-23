# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Newspaper`
module Hyrax
  class NewspaperPresenter < Hyku::WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Newspaper
    delegate(*delegated_properties, to: :solr_document)
  end
end
