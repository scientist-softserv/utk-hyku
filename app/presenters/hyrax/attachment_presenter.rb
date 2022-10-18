# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Attachment`
module Hyrax
  class AttachmentPresenter < Hyku::WorkShowPresenter
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Attachment
    delegate(*delegated_properties, to: :solr_document)
  end
end
