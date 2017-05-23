class AddTitleToAccount < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :title, :string
  end
end
