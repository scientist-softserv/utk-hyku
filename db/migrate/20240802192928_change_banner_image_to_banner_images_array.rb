class ChangeBannerImageToBannerImagesArray < ActiveRecord::Migration[5.2]
  def change
    remove_column :sites, :banner_image, :string
    add_column :sites, :banner_images, :string, array: true, default: []
  end
end
