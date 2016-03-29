require 'rails_helper'

RSpec.describe "accounts/new", type: :view do
  before(:each) do
    assign(:account, Account.new(
                       tenant: "MyString",
                       cname: "MyString"
    ))
  end

  it "renders new account form" do
    render

    assert_select "form[action=?][method=?]", accounts_path, "post" do
      assert_select "input#account_tenant[name=?]", "account[tenant]"

      assert_select "input#account_cname[name=?]", "account[cname]"
    end
  end
end
