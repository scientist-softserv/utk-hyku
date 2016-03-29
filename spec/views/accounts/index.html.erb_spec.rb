require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before(:each) do
    assign(:accounts, [
             Account.create!(
               tenant: "Tenant",
               cname: "Cname"
             ),
             Account.create!(
               tenant: "Tenant 2",
               cname: "Cname 2"
             )
           ])
  end

  it "renders a list of accounts" do
    render
    assert_select "tr>td", text: "Tenant".to_s
    assert_select "tr>td", text: "Cname".to_s

    assert_select "tr>td", text: "Tenant 2".to_s
    assert_select "tr>td", text: "Cname 2".to_s
  end
end
