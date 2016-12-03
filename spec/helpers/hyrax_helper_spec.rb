require 'rails_helper'

RSpec.describe HyraxHelper, type: :helper do
  describe "#banner_image" do
    context "with uploaded banner image" do
      before do
        f = fixture_file_upload('/images/nypl-hydra-of-lerna.jpg', 'image/jpg')
        Site.instance.update(banner_image: f)
      end

      it "returns the uploaded banner image" do
        expect(helper.banner_image).to eq(Site.instance.banner_image.url)
      end
    end

    context "without uploaded banner image" do
      it "returns the configured Hyrax banner image" do
        expect(helper.banner_image).to eq(Hyrax.config.banner_image)
      end
    end
  end
end
