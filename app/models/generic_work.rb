class GenericWork < ActiveFedora::Base
  include ::Sufia::WorkBehavior
  include ::Sufia::BasicMetadata
  include Sufia::WorkBehavior
  validates :title, presence: { message: 'Your work must have a title.' }

  self.indexer = WorkIndexer
  self.human_readable_type = 'Work'
end
