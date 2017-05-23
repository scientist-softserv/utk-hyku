class AddInstitutionNameToSite < ActiveRecord::Migration[4.2]
  def change
    add_column :sites, :institution_name, :string
    add_column :sites, :institution_name_full, :string
  end
end
