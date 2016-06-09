class GenericWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  validates :title, presence: { message: 'Your work must have a title.' }

  self.indexer = WorkIndexer
end
