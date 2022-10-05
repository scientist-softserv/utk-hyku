# frozen_string_literal: true

module SharedWorkBehavior
  extend ActiveSupport::Concern

  include ::Hyrax::WorkBehavior
  include CommonValidations
  include BulkraxMetadata
  include AllinsonFlex::DynamicMetadataBehavior
end
