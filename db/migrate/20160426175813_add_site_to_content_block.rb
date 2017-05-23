class AddSiteToContentBlock < ActiveRecord::Migration[4.2]
  def change
    add_reference :content_blocks, :site, index: true, foreign_key: true
  end
end
