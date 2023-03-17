Hyrax::IiifAv::DisplaysIiifAv.module_eval do
  def iiif_viewer?
    # Hyrax::IiifAv overrides Hyrax, to add in audio & video files
    # Here we override Hyrax::IiifAv::DisplaysIiifAv to use
    # IiifPrint::WorkShowPresenterDecorator to also include child work files
    super
  end

  private

    # Overriding iiif_print to include additional file types
    # TODO: remove once config options are available in iiif_print
    def file_type_and_permissions_valid?(presenter)
      current_ability.can?(:read, presenter.id) &&
        (presenter.try(:image?) || presenter.try(:solr_document).try(:image?) ||
        presenter.try(:video?) || presenter.try(:solr_document).try(:video?) ||
        presenter.try(:audio?) || presenter.try(:solr_document).try(:audio?))
    end
end
