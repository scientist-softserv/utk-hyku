RSpec.describe "The splash page", multitenant: true do
  before do
    Capybara.default_host = "http://#{Settings.multitenancy.admin_host}"
  end

  it "shows the page" do
    visit '/'
    expect(page).to have_link 'Get Started', href: account_sign_up_path(locale: 'en')
  end
end
