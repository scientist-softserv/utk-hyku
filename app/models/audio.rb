# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Audio`
class Audio < ActiveFedora::Base
  include SharedWorkBehavior

  self.indexer = AudioIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)

  include AllinsonFlex::DynamicMetadataBehavior
  include ::Hyrax::BasicMetadata
end