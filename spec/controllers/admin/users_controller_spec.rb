RSpec.describe Admin::UsersController do
  context "with an admin user" do
    before do
      sign_in create(:admin)
    end

    describe "#index" do
      it "uses the admin layout" do
        get :index
        expect(response).to render_template('layouts/dashboard')
      end
    end
  end

  context "with an anonymous user" do
    describe "#index" do
      it "is unauthorized" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
end
