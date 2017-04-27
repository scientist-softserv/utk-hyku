class CreateDefaultAdminSetJob < ActiveJob::Base
  def perform(account)
    # Explicitly switch into account context; creation of the default
    # AdminSet must happen in a per-tenant context (vs. global
    # context). Job is serialized before the tenant is created, thus
    # we can't take advantage of ActiveJobTenant here
    AccountElevator.switch!(account.cname)
    AdminSet.find_or_create_default_admin_set_id
  end
end
