class WorkIndexer < Hyrax::WorkIndexer
  include Hyrax::IndexesBasicMetadata
  self.thumbnail_path_service = IIIFThumbnailPathService
end
