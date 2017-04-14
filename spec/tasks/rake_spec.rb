require 'rake'

RSpec.describe "Rake tasks" do
  describe "superadmin:grant" do
    let!(:user1) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }

    before do
      load_rake_environment [File.expand_path("../../../lib/tasks/grant_superadmin.rake", __FILE__)]
      user1.remove_role :superadmin
      user2.remove_role :superadmin
    end

    it 'requires user_list argument' do
      expect { run_task('superadmin:grant') }.to raise_error(ArgumentError)
    end

    it 'warns when a user is not found' do
      expect(run_task('superadmin:grant', 'missing@example.org')).to include 'Could not find user'
    end

    it 'grants a single user the superadmin role' do
      run_task('superadmin:grant', user1.email)
      expect(user1.has_role?(:superadmin)).to eq true
      expect(user2.has_role?(:superadmin)).to eq false
    end

    it 'grants a multiple users the superadmin role' do
      run_task('superadmin:grant', user1.email, user2.email)
      expect(user1.has_role?(:superadmin)).to eq true
      expect(user2.has_role?(:superadmin)).to eq true
    end
  end
end
