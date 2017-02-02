FactoryGirl.define do
  factory :account do
    sequence(:cname) { |_n| srand }
  end
  factory :sign_up_account, class: Account do
    sequence(:name) { |_n| srand }
  end
end
