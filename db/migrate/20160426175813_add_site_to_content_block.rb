class AddSiteToContentBlock < ActiveRecord::Migration
  def change
    add_reference :content_blocks, :site, index: true, foreign_key: true
  end
end
