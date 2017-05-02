class RemoveTitleFromAccounts < ActiveRecord::Migration[5.0]
  def change
    remove_column :accounts, :title, :string
  end
end
