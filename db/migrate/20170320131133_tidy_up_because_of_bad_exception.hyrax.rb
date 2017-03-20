# This migration comes from hyrax (originally 20170307142607)
class TidyUpBecauseOfBadException < ActiveRecord::Migration
  def change
    if Hyrax::PermissionTemplate.column_names.include?('workflow_id')
      Hyrax::PermissionTemplate.all.each do |permission_template|
        workflow_id = permission_template.workflow_id
        next unless workflow_id
        Sipity::Workflow.find(workflow_id).update(active: true)
      end

      begin
        remove_column Hyrax::PermissionTemplate.table_name, :workflow_id
      rescue
      end
    end
  end
end
