class CreateLdBuffers < ActiveRecord::Migration[5.2]
  def change
    create_table :ld_buffers do |t|
      t.string :url
      t.string :label

      t.timestamps
    end
  end
end
