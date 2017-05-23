class AddGroupsToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :group_list, :text
    add_column :users, :groups_last_update, :datetime
  end

  def self.down
    remove_column :users, :group_list
    remove_column :users, :groups_last_update
  end
end
