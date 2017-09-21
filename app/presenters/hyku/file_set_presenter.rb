module Hyku
  class FileSetPresenter < Hyrax::FileSetPresenter
    include DisplaysImage
    # CurationConcern methods
    delegate :rendering_ids, to: :solr_document
  end
end
