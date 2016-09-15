require 'rails_helper'

RSpec.describe AccountSignUpController, type: :controller do
  let(:user) {}

  before do
    sign_in user if user
  end

  # This should return the minimal set of attributes required to create a valid
  # Account. As you add validations to Account, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { name: 'x' }
  end

  let(:invalid_attributes) do
    { tenant: 'missing-cname', cname: '' }
  end

  context 'as an anonymous user' do
    describe "GET #new" do
      it "assigns a new account as @account" do
        get :new
        expect(response).to render_template("layouts/curation_concerns/1_column")
        expect(assigns(:account)).to be_a_new(Account)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        before do
          allow_any_instance_of(CreateAccount).to receive(:create_external_resources)
        end

        it "creates a new Account" do
          expect do
            post :create, params: { account: valid_attributes }
          end.to change(Account, :count).by(1)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved account as @account" do
          post :create, params: { account: invalid_attributes }
          expect(assigns(:account)).to be_a_new(Account)
        end

        it "re-renders the 'new' template" do
          post :create, params: { account: invalid_attributes }
          expect(response).to render_template("new")
        end
      end
    end
  end
end
