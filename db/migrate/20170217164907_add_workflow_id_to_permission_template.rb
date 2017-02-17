class AddWorkflowIdToPermissionTemplate < ActiveRecord::Migration[5.0]
  ## NOTICE: this is a destructive migration. It is not preserving the permission_template relationship
  def change
    remove_column :permission_templates, :workflow_name
    add_reference :permission_templates, :workflow, index: true
  end
end
