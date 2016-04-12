require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  before do
    sign_in user
  end

  # This should return the minimal set of attributes required to create a valid
  # Site. As you add validations to Site, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { site_roles: ['admin'] }
  end

  let(:invalid_attributes) do
    skip
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SitesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context 'with an unprivileged user' do
    let(:user) { FactoryGirl.create(:user) }

    describe "GET #edit" do
      it "denies the request" do
        get :index, {}
        expect(response).not_to have_http_status(200)
      end
    end

    describe "PUT #update" do
      it "denies the request" do
        put :update, id: user.id
        expect(response).not_to have_http_status(201)
      end
    end
  end

  context 'with an administrator' do
    let(:user) { FactoryGirl.create(:admin) }

    describe "GET #index" do
      it "assigns the users as @site" do
        get :index, {}, valid_session
        expect(assigns(:users)).to match_array [user]
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          { site_roles: ['admin', 'superadmin'] }
        end

        it "updates the requested site" do
          put :update, { id: user.id, user: new_attributes }, valid_session
          user.reload
          expect(user.site_roles.pluck(:name)).to match_array ['admin', 'superadmin']
        end

        it "assigns the requested site as @site" do
          put :update, { id: user.id, user: valid_attributes }, valid_session
          expect(assigns(:user)).to eq(user)
        end

        it "redirects to the site roles" do
          put :update, { id: user.id, user: valid_attributes }, valid_session
          expect(response).to redirect_to(site_roles_path)
        end
      end
    end
  end
end
