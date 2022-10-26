# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Attachment`
module Hyrax
  # Generated form for Attachment
  class AttachmentForm < Hyrax::Forms::WorkForm
    self.model_class = ::Attachment
    self.terms += [:resource_type]
    include AllinsonFlex::DynamicFormBehavior
    include UtkBaseTerms
  end
end
