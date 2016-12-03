require 'rails_helper'

RSpec.describe 'Site content blocks configuration' do
  context 'as an administrator' do
    let(:user) { FactoryGirl.create(:admin) }

    before do
      login_as(user, scope: :user)
    end

    describe 'homepage content blocks' do
      before do
        Site.update(
          announcement_text: 'FOO',
          marketing_text: 'BAZ',
          featured_researcher: 'QUUX'
        )
      end
      it 'updates the homepage' do
        visit root_path
        expect(page).to have_content('FOO')
        expect(page).to have_content('BAZ')
        expect(page).to have_content('QUUX')
      end
    end

    describe 'about page content blocks' do
      before do
        Site.update(
          about_page: 'FOOM'
        )
      end
      it 'updates the about page' do
        visit hyrax.about_path
        expect(page).to have_content('FOOM')
      end
    end
  end
end
