require "rails_helper"

RSpec.describe SitesController, type: :routing do
  describe "routing" do
    it "routes to #edit" do
      expect(get: "/site/edit").to route_to("sites#edit")
    end
    it "routes to #update via PUT" do
      expect(put: "/site").to route_to("sites#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/site").to route_to("sites#update")
    end
  end
end
