class AddSolrEndpointToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :accounts, :string
    add_column :accounts, :solr_endpoint_id, :integer
  end
end
