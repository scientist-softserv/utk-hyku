class AddIndexToAccounts < ActiveRecord::Migration[5.0]
  def change
    # Remove first, else error like:
    # Index name 'index_accounts_on_solr_endpoint_id' on table 'accounts' already exists
    remove_index :accounts, :solr_endpoint_id
    remove_index :accounts, :fcrepo_endpoint_id
    remove_index :accounts, :redis_endpoint_id
    add_foreign_key :accounts, :endpoints, column: :solr_endpoint_id, on_delete: :nullify
    add_foreign_key :accounts, :endpoints, column: :fcrepo_endpoint_id, on_delete: :nullify
    add_foreign_key :accounts, :endpoints, column: :redis_endpoint_id, on_delete: :nullify
    add_index :accounts, :solr_endpoint_id, unique: true
    add_index :accounts, :fcrepo_endpoint_id, unique: true
    add_index :accounts, :redis_endpoint_id, unique: true
  end
end
