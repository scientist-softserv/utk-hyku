# frozen_string_literal: true

# OVERRIDE HYRAX 3.4.1 to skip derivative job if rdf_type is "pcdm-muse:PreservationFile"
module Hyrax
  module CreateDerivativesJobDecorator
    PRESERVATION_FILE = "PreservationFile".downcase

    # @param [FileSet] file_set
    # @param [String] file_id identifier for a Hydra::PCDM::File
    # @param [String, NilClass] filepath the cached file within the Hyrax.config.working_path
    def perform(file_set, file_id, filepath = nil, _time_to_live = 2)
      return if file_set.video? && !Hyrax.config.enable_ffmpeg
      # OVERRIDE HYRAX 3.4.1 to skip derivative job if rdf_type is "pcdm-muse:PreservationFile"
      if file_set.parent_works.blank?
        raise 'CreateDerivatesJob Failed: FileSet is missing its parent' if time_to_live.zero?

        reschedule(file_set, file_id, filepath)
        return false
      end

      return if file_set.rdf_type.present? && file_set.rdf_type.downcase.include?(PRESERVATION_FILE)

      # Ensure a fresh copy of the repo file's latest version is being worked on, if no filepath is directly provided
      unless filepath && File.exist?(filepath)
        filepath = Hyrax::WorkingDirectory.copy_repository_resource_to_working_directory(
          Hydra::PCDM::File.find(file_id), file_set.id
        )
      end

      file_set.create_derivatives(filepath)

      # Reload from Fedora and reindex for thumbnail and extracted text
      file_set.reload
      file_set.update_index
      file_set.parent.update_index if parent_needs_reindex?(file_set)
    end

    private

      def reschedule(file_set, file_id, filepath = nil, _time_to_live = 2)
        CreateDerivativesJob.set(wait: 10.minutes).perform_later(
          file_set, file_id, filepath, time_to_live - 1
        )
      end
  end
end

Hyrax::CreateDerivativesJob.prepend(Hyrax::CreateDerivativesJobDecorator)
