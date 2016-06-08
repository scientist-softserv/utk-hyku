require 'rails_helper'

RSpec.describe "The splash page" do
  it "shows the page" do
    visit '/splash'
    expect(page).to have_link 'Get Started'
  end
end
