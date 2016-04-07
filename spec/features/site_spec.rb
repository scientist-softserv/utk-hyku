require 'rails_helper'

RSpec.describe 'Site Configuration' do
  context 'as an administrator' do
    let(:user) { FactoryGirl.create(:admin) }

    before do
      login_as(user, scope: :user)
    end

    describe 'application name' do
      it 'updates the application name in the brand bar' do
        visit edit_site_path
        fill_in 'Application name', with: 'Custom Name'
        click_on 'Update Site'
        expect(page).to have_css '.navbar-brand', text: 'Custom Name'
      end

      it 'updates the application name in the <head> <title>' do
        visit edit_site_path
        fill_in 'Application name', with: 'Custom Name'
        click_on 'Update Site'

        expect(page).to have_css 'head title', text: 'Custom Name', visible: false
      end
    end
  end
end
