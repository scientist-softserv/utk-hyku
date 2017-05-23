class CreateSites < ActiveRecord::Migration[4.2]
  def change
    create_table :sites do |t|
      t.string :application_name

      t.timestamps null: false
    end
  end
end
