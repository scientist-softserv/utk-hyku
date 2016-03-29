require 'rails_helper'

RSpec.describe "accounts/show", type: :view do
  before(:each) do
    @account = assign(:account, Account.create!(
                                  tenant: "Tenant",
                                  cname: "Cname"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Tenant/)
    expect(rendered).to match(/Cname/)
  end
end
