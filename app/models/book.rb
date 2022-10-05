# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Book`
class Book < ActiveFedora::Base
  include SharedWorkBehavior

  self.indexer = BookIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)

  include ::Hyrax::BasicMetadata
end
