require 'rails_helper'

RSpec.describe 'Admin Dashboard' do
  context 'as an administrator' do
    let(:user) { FactoryGirl.create(:admin) }

    before do
      login_as(user, scope: :user)
    end

    it 'shows the admin page' do
      visit Sufia::Engine.routes.url_helpers.admin_path
      within '.page-sidebar' do
        expect(page).to have_link('Statistics')
        expect(page).to have_link('Labels')
        expect(page).to have_link('Content Blocks')
        expect(page).to have_link('Technical')
        expect(page).to have_link('Administrative Sets')
        expect(page).to have_link('Roles and permissions')
      end
    end
  end
end
