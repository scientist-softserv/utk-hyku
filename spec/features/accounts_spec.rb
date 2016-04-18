require 'rails_helper'

RSpec.describe 'Accounts administration' do
  context 'as an superadmin' do
    let(:user) { FactoryGirl.create(:superadmin) }
    let(:account) { FactoryGirl.create(:account) }

    before do
      login_as(user, scope: :user)
    end

    it 'changes the associated cname' do
      visit edit_account_path(account)

      fill_in 'Cname', with: 'example.com'

      click_on 'Update Account'

      account.reload

      expect(account.cname).to eq 'example.com'
    end

    it 'changes the solr endpoint url' do
      visit edit_account_path(account)

      fill_in 'Url', with: 'http://example.com/solr/'

      click_on 'Update Account'

      account.reload

      expect(account.solr_endpoint.url).to eq 'http://example.com/solr/'
    end
  end
end
