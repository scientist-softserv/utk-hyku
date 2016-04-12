RSpec.configure do |config|
  config.before(:each) do
    account = FactoryGirl.create(:account)
    Site.update(account: account)
  end
end
