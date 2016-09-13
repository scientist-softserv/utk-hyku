# This migration comes from sufia (originally 20160825110405)
class DropFollows < ActiveRecord::Migration
  def self.up
    drop_table :follows
  end
end
