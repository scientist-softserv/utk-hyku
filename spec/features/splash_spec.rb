RSpec.describe "The splash page", multitenant: true do
  before do
    Capybara.default_host = "http://#{Account.admin_host}"
  end

  it "shows the page, displaying the Hyku version" do
    visit '/'
    expect(page).to have_link 'Login to get started', href: main_app.new_user_session_path(locale: 'en')

    within 'footer' do
      expect(page).to have_link 'Administrator login'
    end

    expect(page).to have_content("Hyku v#{Hyku::VERSION}")
  end
end
