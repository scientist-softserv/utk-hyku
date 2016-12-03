class FileSetIndexer < Sufia::FileSetIndexer
  self.thumbnail_path_service = IIIFThumbnailPathService
end
