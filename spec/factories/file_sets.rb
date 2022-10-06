# frozen_string_literal: true

FactoryBot.define do
  factory :file_set do
    transient do
      user { FactoryBot.create(:user) }
    end

    trait :image do
      content { File.open(Hyrax::Engine.root + 'spec/fixtures/world.png') }
    end

    after(:build) do |fs, evaluator|
      fs.apply_depositor_metadata evaluator.user
    end
  end
end
