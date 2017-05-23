class ChangeAuditLogPidToGenericFileId < ActiveRecord::Migration[4.2]
  def change
    rename_column :checksum_audit_logs, :pid, :generic_file_id if ChecksumAuditLog.column_names.include?('pid')
  end
end
