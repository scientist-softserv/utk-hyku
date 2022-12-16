# frozen_string_literal: true

module ApplicationHelper
  include ::HyraxHelper
  include GroupNavigationHelper
  include SharedSearchHelper

  # OVERRIDE
  include Hyrax::HyraxHelperBehaviorDecorator
  # OVERRIDE
  include Hyrax::CollectionsHelperDecorator
end
