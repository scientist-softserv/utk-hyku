# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Book`
module Hyrax
  # Generated form for Book
  class BookForm < Hyrax::Forms::WorkForm
    self.model_class = ::Book
    self.terms += [:resource_type]
    include AllinsonFlex::DynamicFormBehavior
    include UtkBaseTerms
  end
end
