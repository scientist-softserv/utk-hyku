CurationConcerns.configure do |config|
  # Injected via `rails g curation_concerns:work GenericWork`
  config.register_curation_concern :generic_work
end

Date::DATE_FORMATS[:standard] = '%m/%d/%Y'
