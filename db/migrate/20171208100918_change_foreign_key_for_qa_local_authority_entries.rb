class ChangeForeignKeyForQaLocalAuthorityEntries < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :qa_local_authority_entries, :local_authorities
    add_foreign_key :qa_local_authority_entries, :qa_local_authorities, column: :local_authority_id,  index: true
  end
end
