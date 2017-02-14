RSpec.feature 'Creating a new Work' do
  let(:user) { create(:user) }

  before do
    login_as user, scope: :user
  end

  it 'creates the work' do
    visit '/'
    click_link "Share Your Work"
    expect(page).to have_button "Create work"
  end
end
