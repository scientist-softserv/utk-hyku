class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :tenant, unique: true
      t.string :cname, unique: true

      t.timestamps null: false
    end
    
    add_index :accounts, [:cname, :tenant]
  end
end
