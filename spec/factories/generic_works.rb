# frozen_string_literal: true

FactoryBot.define do
  factory :generic_work do
    title { ["Test title"] }
    visibility { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    state { "complete" }

    transient do
      user { FactoryBot.create(:user) }
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end

    factory :generic_work_with_one_file do
      after(:build) do |work, evaluator|
        work.ordered_members << file_set = FactoryBot.create(
          :file_set,
          :image,
          user: evaluator.user,
          title: ['A Contained FileSet'],
          label: 'world.png'
        )
        work.representative = file_set if work.representative_id.blank?
        work.thumbnail = file_set if work.thumbnail_id.blank?
        work.save
      end
    end
  end
end
