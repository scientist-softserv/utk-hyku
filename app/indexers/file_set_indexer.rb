class FileSetIndexer < Hyrax::FileSetIndexer
  self.thumbnail_path_service = IIIFThumbnailPathService
end
