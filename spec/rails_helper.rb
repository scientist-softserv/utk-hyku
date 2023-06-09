# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

# In test most, unset some variables that can cause trouble
# before booting up Rails
ENV['HYKU_ADMIN_HOST'] = 'test.host'
ENV['HYKU_ROOT_HOST'] = 'test.host'
ENV['HYKU_ADMIN_ONLY_TENANT_CREATION'] = nil
ENV['HYKU_DEFAULT_HOST'] = nil
ENV['HYKU_MULTITENANT'] = 'true'

require 'simplecov'
SimpleCov.start('rails')

require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'database_cleaner'
require 'active_fedora/cleaner'
require 'webdrivers'
require 'shoulda/matchers'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Ensure the Hyrax::Admin constant is loaded. Because testing is done using autoloading,
# the order of the test run determines where the constants are loaded from.  Prior to
# this change we were seeing intermittent errors like:
#   uninitialized constant Admin::UserActivityPresenter
# This can probably be removed once https://github.com/projecthydra-labs/hyrax/pull/440
# is merged
# rubocop:disable Lint/Void
Hyrax::Admin
# rubocop:enable Lint/Void

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# Uses faster rack_test driver when JavaScript support not needed
Capybara.default_max_wait_time = 8
Capybara.default_driver = :rack_test

ENV['WEB_HOST'] ||= `hostname -s`.strip

if ENV['CHROME_HOSTNAME'].present?
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[headless disable-gpu no-sandbox whitelisted-ips window-size=1400,1400]
    }
  )

  Capybara.register_driver :chrome do |app|
    d = Capybara::Selenium::Driver.new(app,
                                       browser: :remote,
                                       desired_capabilities: capabilities,
                                       url: "http://#{ENV['CHROME_HOSTNAME']}:4444/wd/hub")
    # Fix for capybara vs remote files. Selenium handles this for us
    d.browser.file_detector = lambda do |args|
      str = args.first.to_s
      str if File.exist?(str)
    end
    d
  end
  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = 3001
  Capybara.app_host = "http://#{ENV['WEB_HOST']}:#{Capybara.server_port}"
else
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[headless disable-gpu]
    }
  )

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities
    )
  end
end

Capybara.javascript_driver = :chrome

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Fixtures::FixtureFileUpload
  config.include FactoryBot::Syntax::Methods
  config.include ApplicationHelper, type: :view
  config.include Warden::Test::Helpers, type: :feature
  config.include ActiveJob::TestHelper

  config.before(:each, type: :feature) do
    skip("TODO: address in #418")
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    Account.destroy_all
    CreateSolrCollectionJob.new.without_account('hydra-test') if ENV['IN_DOCKER']
    CreateSolrCollectionJob.new.without_account('hydra-sample')
    CreateSolrCollectionJob.new.without_account('hydra-cross-search-tenant', 'hydra-test, hydra-sample')
    # AdminSet.find_or_create_default_admin_set_id
    # profile_path = Rails.root.join('spec', 'fixtures', 'allinson_flex', 'yaml_example.yml')
    # allinson_flex_profile = AllinsonFlex::Importer.load_profile_from_path(path: profile_path.to_s)
    # allinson_flex_profile.save
  end

  config.before do |example|
    # make sure we are on the default fedora config
    ActiveFedora::Fedora.reset!
    ActiveFedora::SolrService.reset!
    # Pass `:clean' to destroy objects in fedora/solr and start from scratch
    ActiveFedora::Cleaner.clean! if example.metadata[:clean]
    if example.metadata[:type] == :feature && Capybara.current_driver != :rack_test
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
    AdminSet.create id: AdminSet::DEFAULT_ID, title: Array.wrap(AdminSet::DEFAULT_TITLE) if example.metadata[:clean]
  end

  # TODO: There has to be a better/faster way to do this
  config.before(:each) do
    AdminSet.find_or_create_default_admin_set_id
    profile_path = Rails.root.join('spec', 'fixtures', 'allinson_flex', 'yaml_example.yml')
    allinson_flex_profile = AllinsonFlex::Importer.load_profile_from_path(path: profile_path.to_s)
    allinson_flex_profile.save
    AllinsonFlex::Context.all.each do |context|
      context.update(admin_set_ids: [AdminSet&.last&.id])
    end
  end

  config.after(:each, type: :feature) do |example|
    # rubocop:disable Lint/Debugger
    save_timestamped_page_and_screenshot(Capybara.page, example.metadata) if example.exception.present?
    # rubocop:enable Lint/Debugger
    Warden.test_reset!
    Capybara.reset_sessions!
    page.driver.reset!
  end

  config.after do
    begin
      DatabaseCleaner.clean
    rescue NoMethodError
      'This can happen which the database is gone, which depends on load order of tests'
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

def save_timestamped_page_and_screenshot(page, meta)
  filename = File.basename(meta[:file_path])
  line_number = meta[:line_number]

  time_now = Time.zone.now
  # rubocop:disable Style/FormatStringToken
  timestamp = format('%<year>s-%<month>s-%<day>s-%<hour>s-%<minute>s-%<second>s.%<millis>s',
                     year: time_now.strftime('%Y'),
                     month: time_now.strftime('%m'),
                     day: time_now.strftime('%d'),
                     hour: time_now.strftime('%H'),
                     minute: time_now.strftime('%M'),
                     second: time_now.strftime('%S'),
                     millis: format('%03d', (time_now.usec / 1000).to_i))
  # rubocop:enable Style/FormatStringToken

  screenshot_name = "screenshot-#{filename}-#{line_number}-#{timestamp}.png"
  # rubocop:disable Rails/FilePath
  screenshot_path = Rails.root.join('tmp/capybara', screenshot_name).to_s
  # rubocop:enable Rails/FilePath
  page.save_screenshot(screenshot_path)

  page_name = "html-#{filename}-#{line_number}-#{timestamp}.html"
  # rubocop:disable Rails/FilePath
  page_path = Rails.root.join('tmp/capybara', page_name).to_s
  # rubocop:enable Rails/FilePath
  page.save_page(page_path)

  puts "\n  Screenshot: tmp/capybara/#{screenshot_name}"
  puts "  HTML: tmp/capybara/#{page_name}"
end