# This data is loaded with the rake db:seed (or created alongside the db with db:setup).
# The bin/setup command will also invoke this
# Note: Fedora and Solr must be running for this to work
# Note: In a multitenant environment these actions must be taken only after the
#       solr & fedora for the tenant has been created so we keep
#       Apartment.seed_after_create = false (the default value)

unless ActiveModel::Type::Boolean.new.cast(ENV.fetch('HYKU_MULTITENANT', false))
  puts "\n== Creating single tenant resources"
  single_tenant_default = Account.find_by(cname: 'single.tenant.default')
  if single_tenant_default.blank?
    single_tenant_default = Account.new(name: 'Single Tenant', cname: 'single.tenant.default', tenant: 'single', is_public: true)
    CreateAccount.new(single_tenant_default).save
    raise "Account creation failed for #{single_tenant_default.errors.full_messages}" unless single_tenant_default.valid?
    single_tenant_default = single_tenant_default.reload
  end
  AccountElevator.switch!(single_tenant_default.cname)

  puts "\n== Creating default admin set"
  admin_set = AdminSet.find(AdminSet.find_or_create_default_admin_set_id)

  puts "\n== Creating default collection types"
  Hyrax::CollectionType.find_or_create_default_collection_type
  Hyrax::CollectionType.find_or_create_admin_set_type

  puts "\n== Loading workflows"
  Hyrax::Workflow::WorkflowImporter.load_workflows
  errors = Hyrax::Workflow::WorkflowImporter.load_errors
  abort("Failed to process all workflows:\n  #{errors.join('\n  ')}") unless errors.empty?

  puts "\n== Creating permission template"
  begin
    permission_template = admin_set.permission_template
  # If the permission template is missing we will need to run the creete service
  rescue
    Hyrax::AdminSetCreateService.new(admin_set: admin_set, creating_user: nil).create
  end

  puts "\n== Finished creating single tenant resources"
end

# Account.find_each do |account|
#   Apartment::Tenant.switch!(account.tenant)
#   next if Site.instance.available_works.present?
#   Site.instance.available_works = Hyrax.config.registered_curation_concern_types
#   Site.instance.save
# end

if ENV['INITIAL_ADMIN_EMAIL'] && ENV['INITIAL_ADMIN_PASSWORD']
  u = User.find_or_create_by(email: ENV['INITIAL_ADMIN_EMAIL']) do |u|
    u.password = ENV['INITIAL_ADMIN_PASSWORD']
    u.add_role(:superadmin)
  end
  puts "\n== Finished seeding the default superadmin user"
end

if ENV['SUPPORT_EMAIL'] && ENV['SUPPORT_PASSWORD']
  u = User.find_or_create_by(email: ENV['SUPPORT_EMAIL']) do |u|
    u.password = ENV['SUPPORT_PASSWORD']
    u.add_role(:superadmin)
  end
  puts "\n== Finished seeding the superadmin notch8 support user"
end

if ENV['ROB_EMAIL'] && ENV['ROB_PASSWORD']
  u = User.find_or_create_by(email: ENV['ROB_EMAIL']) do |u|
    u.password = ENV['ROB_PASSWORD']
    u.add_role(:superadmin)
  end
  puts "\n== Finished seeding Rob's superadmin user"
end

if ENV['INITIAL_USER_EMAIL'] && ENV['INITIAL_USER_PASSWORD']
  u = User.find_or_create_by(email: ENV['INITIAL_USER_EMAIL']) do |u|
    u.password = ENV['INITIAL_USER_PASSWORD']
  end
  puts "\n== Finished seeding the default registered user"
end

if ENV['TEST_USER_EMAIL'] && ENV['TEST_USER_PASSWORD']
  u = User.find_or_create_by(email: ENV['TEST_USER_EMAIL']) do |u|
    u.password = ENV['TEST_USER_PASSWORD']
  end
  puts "\n== Finished seeding the default notch8 registered user"
end
