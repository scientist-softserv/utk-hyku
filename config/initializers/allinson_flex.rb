# frozen_string_literal: true

AllinsonFlex.setup do |config|
  # Use a different base repository for the m3 json schema (eg. a fork)
  # Default:
  #
  # config.m3_schema_repository = 'https://raw.githubusercontent.com/samvera-labs/houndstooth'

  # Use a different version (eg. commit hash)
  # Default:
  #
  # config.m3_schema_version_tag = 'main'
end
Hyrax::CurationConcern.actor_factory.insert_before Hyrax::Actors::ModelActor, AllinsonFlex::DynamicSchemaActor
