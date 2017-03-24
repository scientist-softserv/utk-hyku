# Generated via
#  `rails generate curation_concerns:work Image`
include Warden::Test::Helpers

RSpec.feature 'Create a Image', js: true do
  context 'a logged in user' do
    let(:user) { create(:user) }

    before do
      login_as user, scope: :user
    end

    scenario do
      visit '/dashboard'
      click_link "Works"
      click_link "Add new work"
      choose "payload_concern", option: "Image"
      click_button "Create work"
    end
  end
end
