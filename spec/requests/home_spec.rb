require 'rails_helper'

RSpec.describe 'Home page', type: :request do
  context 'without a current tenant' do
    describe 'GET /' do
      it 'redirects to the accounts landing page' do
        get root_path
        expect(response).to redirect_to(accounts_path)
      end
    end
  end
end
