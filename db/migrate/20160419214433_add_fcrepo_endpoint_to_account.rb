class AddFcrepoEndpointToAccount < ActiveRecord::Migration
  def change
    add_reference :accounts, :fcrepo_endpoint, index: true
  end
end
