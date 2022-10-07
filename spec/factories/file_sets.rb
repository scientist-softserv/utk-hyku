# frozen_string_literal: true

FactoryBot.define do
  factory :file_set do
    transient do
      user { FactoryBot.create(:user) }
      content { nil }
    end

    after(:build) do |fs, evaluator|
      fs.apply_depositor_metadata evaluator.user
    end

    after(:create) do |file, evaluator|
      Hydra::Works::UploadFileToFileSet.call(file, evaluator.content) if evaluator.content
    end

    trait :image do
      content { File.open(Rails.root.join('spec', 'fixtures', 'world.png')) }
    end
  end
end
