class AddFcrepoEndpointToAccount < ActiveRecord::Migration[4.2]
  def change
    add_reference :accounts, :fcrepo_endpoint, index: true
  end
end
