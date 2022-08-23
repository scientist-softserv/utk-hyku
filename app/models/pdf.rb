# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Pdf`
class Pdf < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include BulkraxMetadata

  self.indexer = PdfIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title,
            presence: { message: 'Your work must have a title.' },
            length: { maximum: 1, message: 'Your work can only have one title.' }

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)

  include AllinsonFlex::DynamicMetadataBehavior
  include ::Hyrax::BasicMetadata
end
