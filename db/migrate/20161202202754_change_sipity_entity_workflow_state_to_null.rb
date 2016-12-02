class ChangeSipityEntityWorkflowStateToNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:sipity_entities, :workflow_state_id, true)
  end
end
