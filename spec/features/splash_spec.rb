require 'rails_helper'

RSpec.describe "The splash page" do
  it "shows the page" do
    visit '/splash'
    expect(page).to have_link 'Get Started', href: account_sign_up_path
  end
end
