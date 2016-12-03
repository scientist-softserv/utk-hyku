require 'rails_helper'

RSpec.describe Hyrax::MailboxController do
  routes { Hyrax::Engine.routes }

  before do
    sign_in create(:user)
  end

  describe "#index" do
    it 'uses the admin layout' do
      get :index
      expect(response).to render_template("admin")
    end
  end
end
