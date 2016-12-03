class AddLabelToSipityWorkflows < ActiveRecord::Migration[5.0]
  def change
    add_column :sipity_workflows, :label, :string
  end
end
