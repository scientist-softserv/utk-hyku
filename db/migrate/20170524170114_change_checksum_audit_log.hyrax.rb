# This migration comes from hyrax (originally 20170504192714)
class ChangeChecksumAuditLog < ActiveRecord::Migration[5.0]
  def up
    rename_column :checksum_audit_logs, :version, :checked_uri
    add_column :checksum_audit_logs, :passed, :boolean
    execute 'UPDATE checksum_audit_logs SET passed = (pass = 1)'
    remove_column :checksum_audit_logs, :pass
    add_index     :checksum_audit_logs, :checked_uri
  end
end
