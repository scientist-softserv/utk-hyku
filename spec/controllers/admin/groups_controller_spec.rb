require 'rails_helper'

RSpec.describe Admin::GroupsController do
  context 'as an anonymous user' do
    describe 'GET #index' do
      it 'is unauthorized' do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'as an admin user' do
    before { sign_in create(:admin) }

    describe 'GET #index' do
      it 'uses the admin layout' do
        get :index
        expect(response).to render_template('layouts/admin')
      end
    end

    describe 'GET #new' do
    end

    describe 'POST #create' do
    end

    describe 'GET #edit' do
    end

    describe 'PUT #update' do
    end

    describe 'GET #remove' do
    end

    describe 'DELETE #destroy' do
    end
  end
end
