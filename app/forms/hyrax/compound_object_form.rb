# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work CompoundObject`
module Hyrax
  # Generated form for CompoundObject
  class CompoundObjectForm < Hyrax::Forms::WorkForm
    self.model_class = ::CompoundObject
    self.terms += [:resource_type]
    include AllinsonFlex::DynamicFormBehavior
    include UtkBaseTerms
  end
end
