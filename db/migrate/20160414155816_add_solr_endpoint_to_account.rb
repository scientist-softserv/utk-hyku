class AddSolrEndpointToAccount < ActiveRecord::Migration[4.2]
  def change
    add_reference :accounts, :solr_endpoint, index: true
  end
end
