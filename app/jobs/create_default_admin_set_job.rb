class CreateDefaultAdminSetJob < ActiveJob::Base
  def perform(_account)
    AdminSet.find_or_create_default_admin_set_id
  end
end
