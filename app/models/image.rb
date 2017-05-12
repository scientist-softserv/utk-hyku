class Image < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  validates :title, presence: { message: 'Your work must have a title.' }

  property :extent, predicate: ::RDF::Vocab::DC.extent, multiple: true do |index|
    index.as :stored_searchable
  end

  # This must come after the custom properties because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata

  # This indexer uses IIIF thumbnails:
  self.indexer = WorkIndexer
  self.human_readable_type = 'Image'

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
end
