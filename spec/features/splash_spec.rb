RSpec.describe "The splash page" do
  before do
    Capybara.default_host = "http://#{Settings.multitenancy.admin_host}"
  end

  it "shows the page" do
    visit '/splash'
    expect(page).to have_link 'Get Started', href: account_sign_up_path(locale: 'en')
  end
end
