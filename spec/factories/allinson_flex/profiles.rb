# frozen_string_literal: true

FactoryBot.define do
  factory :allinson_flex_profile, class: AllinsonFlex::Profile do
    name { "University of Tennessee" }
    sequence(:profile_version) { |n| n }
    responsibility { 'https://www.lib.utk.edu' }
    date_modified { '2022-10-04' }
    profile_classes { [FactoryBot.build(:allinson_flex_class)] }
    profile_contexts { [FactoryBot.build(:profile_context)] }
    properties { [FactoryBot.build(:allinson_flex_property)] }
    profile { File.read('spec/fixtures/allinson_flex/yaml_example.yaml') }
  end

  factory :allinson_flex_class, class: AllinsonFlex::ProfileClass do
    name            { "Image" }
    display_label   { "Flexible Work" }
    profile_contexts { [FactoryBot.build(:profile_context)] }
    class_texts { [FactoryBot.build(:allinson_flex_text_for_class)] }
  end

  factory :profile_context, class: AllinsonFlex::ProfileContext do
    name            { "flexible_context" }
    display_label   { "Flexible Context" }
    context_texts { [FactoryBot.build(:allinson_flex_text_for_context)] }
  end

  factory :allinson_flex_property, class: AllinsonFlex::ProfileProperty do
    name            { "title" }
    indexing        { ['stored_searchable'] }
    available_on_classes { [FactoryBot.build(:allinson_flex_class)] }
    available_on_contexts { [FactoryBot.build(:profile_context)] }
    texts do
      [
        FactoryBot.build(:allinson_flex_text),
        FactoryBot.build(:allinson_flex_text_for_class),
        FactoryBot.build(:allinson_flex_text_for_context)
      ]
    end
  end

  factory :allinson_flex_text, class: AllinsonFlex::ProfileText do
    name { "display_label" }
    value { "Title" }
  end

  factory :allinson_flex_text_for_class, class: AllinsonFlex::ProfileText do
    name            { "display_label" }
    value           { "Title in Class" }
  end

  factory :allinson_flex_text_for_context, class: AllinsonFlex::ProfileText do
    name            { "display_label" }
    value { "Title in Context" }
  end
end
