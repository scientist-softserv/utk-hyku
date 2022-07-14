# frozen_string_literal: true

# require_relative 'prepend_permission_templates_controller'
#  models
AdminSet.class_eval do
  include AllinsonFlex::AdminSetBehavior
end

#  controllers
# Hyrax::Admin::PermissionTemplatesController.prepend AllinsonFlex::PrependPermissionTemplatesController

#  forms
# Hyrax::Forms::AdminSetForm.prepend AllinsonFlex::PrependAdminSetForm
# Hyrax::Forms::PermissionTemplateForm.prepend AllinsonFlex::PrependPermissionTemplateForm
