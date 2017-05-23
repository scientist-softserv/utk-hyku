class AddNameToAccount < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :name, :string
  end
end
