FactoryGirl.define do
  factory :account do
    sequence(:name) { |_n| srand }
  end
end
