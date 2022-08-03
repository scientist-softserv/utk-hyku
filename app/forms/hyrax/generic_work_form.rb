# frozen_string_literal: true

# Generated via
#  `rails generate curation_concerns:work GenericWork`
module Hyrax
  class GenericWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::GenericWork
    include HydraEditor::Form::Permissions
    include AllinsonFlex::DynamicFormBehavior
  end
end
