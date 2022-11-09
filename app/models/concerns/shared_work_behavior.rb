# frozen_string_literal: true

module SharedWorkBehavior
  extend ActiveSupport::Concern

  include ::Hyrax::WorkBehavior
  include CommonValidations
  include BulkraxMetadata
  include AllinsonFlex::DynamicMetadataBehavior
  include DestroyAttachments

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include AllinsonFlex::FoundationalMetadata
end
