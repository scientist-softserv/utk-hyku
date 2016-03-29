require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  before do
    allow_any_instance_of(ActiveFedora::Fedora).to receive(:init_base_path)
  end
  describe "GET /accounts" do
    it "works! (now write some real specs)" do
      get accounts_path
      expect(response).to have_http_status(200)
    end
  end
end
