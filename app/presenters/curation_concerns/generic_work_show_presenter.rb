class CurationConcerns::GenericWorkShowPresenter < Sufia::WorkShowPresenter
  self.file_presenter_class = Hybox::FileSetPresenter

  def initialize(solr_document, ability, hostname)
    super(solr_document, ability)
    @hostname = hostname
  end

  def manifest_url
    manifest_helper.polymorphic_url([:manifest, self])
  end

  private

    def manifest_helper
      @manifest_helper ||= ManifestHelper.new(@hostname)
    end
end
