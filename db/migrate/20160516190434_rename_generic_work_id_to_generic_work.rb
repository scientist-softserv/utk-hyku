class RenameGenericWorkIdToGenericWork < ActiveRecord::Migration[4.2]
  def change
    rename_column :featured_works, :generic_work_id, :work_id if column_exists?(:featured_works, :generic_work_id)
    rename_column :proxy_deposit_requests, :generic_work_id, :work_id if column_exists?(:proxy_deposit_requests, :generic_work_id)
    rename_column :trophies, :generic_work_id, :work_id if column_exists?(:trophies, :generic_work_id)
  end
end
