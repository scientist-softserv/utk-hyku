class AddSolrEndpointToAccount < ActiveRecord::Migration
  def change
    add_reference :accounts, :solr_endpoint, index: true
  end
end
