# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Newspaper`
module Hyrax
  # Generated form for Newspaper
  class NewspaperForm < Hyrax::Forms::WorkForm
    self.model_class = ::Newspaper
    self.terms += [:resource_type]
    include AllinsonFlex::DynamicFormBehavior
    include UtkBaseTerms
  end
end
