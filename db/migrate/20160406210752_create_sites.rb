class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :application_name

      t.timestamps null: false
    end
  end
end
