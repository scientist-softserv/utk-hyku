module Hybox
  class FileSetPresenter < CurationConcerns::FileSetPresenter
    include DisplaysImage

    def initialize(solr_document, ability, hostname)
      super(solr_document, ability)
      @hostname = hostname
    end
  end
end
