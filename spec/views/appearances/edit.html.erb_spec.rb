RSpec.describe "appearances/edit", type: :view do
  let(:site) { Site.create!(application_name: "MyString", institution_name: "My Inst Name") }

  before do
    assign(:site, site)
  end

  it "renders the edit site form" do
    render

    assert_select "form[action=?][method=?]", site_appearances_path, "post" do
      assert_select "input#site_banner_image[name=?]", "site[banner_image]"
      assert_select "input#site_banner_image[type=?]", "file"
    end
  end
end
