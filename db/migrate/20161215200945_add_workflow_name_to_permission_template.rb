class AddWorkflowNameToPermissionTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :permission_templates, :workflow_name, :string
  end
end
