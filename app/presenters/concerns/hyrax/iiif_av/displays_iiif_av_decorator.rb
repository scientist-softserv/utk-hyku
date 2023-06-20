# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
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
      intermediate_file_in?(presenter) && current_ability.can?(:read, presenter.id) &&
        (presenter.try(:image?) || presenter.try(:solr_document).try(:image?) ||
        presenter.try(:video?) || presenter.try(:solr_document).try(:video?) ||
        presenter.try(:audio?) || presenter.try(:solr_document).try(:audio?))
    end

    ##
    # Determines if the presenter has an intermediate file.
    #
    # @param presenter [Object]
    # @return [TrueClass, Nil] 'true' if the presenter has an intermediate file, `nil` otherwise.
    def intermediate_file_in?(presenter)
      @has_intermediate_file ||= determine_intermediate_file(presenter)
      @has_intermediate_file
    end

    ##
    # Determines if an intermediate file exists based on the presenter's `file_set_ids`
    # or `intermediate_file?` methods.
    #
    # @param presenter [Object]
    # @return [TrueClass, Nil] `true` if an intermediate file exists, `nil` if not.
    def determine_intermediate_file(presenter)
      potential_files = presenter.try(:file_set_ids) || presenter.try(:intermediate_file?)

      return unless potential_files

      if potential_files.is_a?(Array)
        intermediate_file_exists?(potential_files)
      else
        true
      end
    end

    ##
    # Checks for the existence of an intermediate file within the provided file set ids.
    #
    # @param file_set_ids [Array]
    # @return [Boolean] `true` if any id in the array has an intermediate file, `false` otherwise.
    def intermediate_file_exists?(file_set_ids)
      file_set_ids.any? { |id| SolrDocument.find(id).intermediate_file? }
    end
end
# rubocop:enable Metrics/BlockLength
