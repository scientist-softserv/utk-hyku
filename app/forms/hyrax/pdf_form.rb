# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Pdf`
module Hyrax
  # Generated form for Pdf
  class PdfForm < Hyrax::Forms::WorkForm
    self.model_class = ::Pdf
    self.terms += [:resource_type]
    include AllinsonFlex::DynamicFormBehavior
    include UtkBaseTerms
  end
end
