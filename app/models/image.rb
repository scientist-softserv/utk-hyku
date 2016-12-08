class Image < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include Hyrax::WorkBehavior
  validates :title, presence: { message: 'Your work must have a title.' }

  # This indexer uses IIIF thumbnails:
  self.indexer = WorkIndexer
  self.human_readable_type = 'Image'

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
end
