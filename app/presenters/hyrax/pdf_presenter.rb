# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Pdf`
module Hyrax
  class PdfPresenter < Hyku::WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Pdf
    delegate(*delegated_properties, to: :solr_document)
  end
end
