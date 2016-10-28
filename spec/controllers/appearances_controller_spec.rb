require 'rails_helper'

RSpec.describe AppearancesController, type: :controller do
  before do
    sign_in user
  end

  let(:valid_attributes) do
    { banner_image: "image.jpg" }
  end

  let(:invalid_attributes) do
    { banner_image: "" }
  end

  context 'with an unprivileged user' do
    let(:user) { FactoryGirl.create(:user) }

    describe "GET #edit" do
      it "denies the request" do
        get :edit
        expect(response).to have_http_status(401)
      end
    end

    describe "PUT #update" do
      it "denies the request" do
        put :update
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'with an administrator' do
    let(:user) { FactoryGirl.create(:admin) }

    describe "GET #edit" do
      it "assigns the requested site as @site" do
        get :edit, params: {}
        expect(assigns(:site)).to eq(Site.instance)
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        it "sets a banner image" do
          expect(Site.instance.banner_image?).to be false
          f = fixture_file_upload('/images/nypl-hydra-of-lerna.jpg', 'image/jpg')
          post :update, params: { site: { banner_image: f } }
          expect(response).to redirect_to(edit_site_appearances_path)
          expect(flash[:notice]).to include("Appearance was successfully updated")
          expect(Site.instance.banner_image?).to be true
        end

        it "assigns the requested site as @site" do
          put :update, params: { site: valid_attributes }
          expect(assigns(:site)).to eq(Site.instance)
        end

        it "redirects to the site" do
          put :update, params: { site: valid_attributes }
          expect(response).to redirect_to(edit_site_appearances_path)
        end
      end

      context "site with existing banner image" do
        before do
          f = fixture_file_upload('/images/nypl-hydra-of-lerna.jpg', 'image/jpg')
          Site.instance.update(banner_image: f)
        end

        it "deletes a banner image" do
          expect(Site.instance.banner_image?).to be true
          post :update, params: { id: Site.instance.id, site: { remove_banner_image: 'true' } }
          expect(response).to redirect_to(edit_site_appearances_path)
          expect(flash[:notice]).to include("Appearance was successfully updated")
          expect(Site.instance.banner_image?).to be false
        end
      end

      context "with invalid params" do
        it "assigns the site as @site" do
          put :update, params: { site: invalid_attributes }
          expect(assigns(:site)).to eq(Site.instance)
        end

        it "re-renders the 'edit' template" do
          put :update, params: { site: invalid_attributes }
          expect(response).to redirect_to(action: "edit")
        end
      end
    end
  end
end
