class AddIndexToAccountsCname < ActiveRecord::Migration[5.0]
  def change
    add_index :accounts, :cname, unique: true
  end
end
