class FileSetIndexer < CurationConcerns::FileSetIndexer
  self.thumbnail_path_service = IIIFThumbnailPathService
end
