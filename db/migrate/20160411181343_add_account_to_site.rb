class AddAccountToSite < ActiveRecord::Migration
  def change
    add_column :sites, :account_id, :integer
  end
end
