class CreateEndpoints < ActiveRecord::Migration[4.2]
  def change
    create_table :endpoints do |t|
      t.string :type
      t.binary :options

      t.timestamps null: false
    end
  end
end
