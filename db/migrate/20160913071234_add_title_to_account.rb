class AddTitleToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :title, :string
  end
end
