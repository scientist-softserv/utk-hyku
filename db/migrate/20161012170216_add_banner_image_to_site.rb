class AddBannerImageToSite < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, "banner_image", :string
  end
end
