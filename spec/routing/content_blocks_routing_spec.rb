RSpec.describe ContentBlocksController, type: :routing do
  describe "routing" do
    it "routes to #edit" do
      expect(get: "/site/content_blocks/edit").to route_to("content_blocks#edit")
    end
    it "routes to #update via PUT" do
      expect(put: "/site/content_blocks").to route_to("content_blocks#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/site/content_blocks").to route_to("content_blocks#update")
    end
  end
end
