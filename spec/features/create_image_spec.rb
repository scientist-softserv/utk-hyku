# Generated via
#  `rails generate curation_concerns:work Image`
include Warden::Test::Helpers

RSpec.feature 'Create a Image' do
  context 'a logged in user' do
    let(:user) { create(:user) }

    before do
      login_as user, scope: :user
    end

    scenario do
      visit '/'
      click_link "Works"
      click_link "New Work"
      expect(page).to have_field "Image"
      expect(page).to have_button "Create work"
    end
  end
end
