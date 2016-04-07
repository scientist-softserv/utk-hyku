FactoryGirl.define do
  factory :user do
    sequence(:email) { |_n| "email-#{srand}@test.com" }
    password 'a password'
    password_confirmation 'a password'
  end

  factory :admin, parent: :user do
    group_list 'admin'
  end
end
