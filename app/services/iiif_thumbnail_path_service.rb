class IIIFThumbnailPathService < Sufia::WorkThumbnailPathService
  class << self
    # TODO: we need to override this method until https://github.com/projecthydra/curation_concerns/pull/843 is merged
    # @param [Work, FileSet] the object to get the thumbnail for
    # @return [String] a path to the thumbnail
    # rubocop:disable Metrics/MethodLength
    def call(object)
      return default_image unless object.thumbnail_id

      thumb = fetch_thumbnail(object)
      return unless thumb
      return call(thumb) unless thumb.is_a?(::FileSet)
      if thumb.audio?
        audio_image
      elsif thumbnail?(thumb)
        thumbnail_path(thumb)
      else
        default_image
      end
    end
    # rubocop:enable Metrics/MethodLength

    protected

      # @param [FileSet] file_set
      # @return the IIIF url for the thumbnail.
      def thumbnail_path(file_set, size = '300,'.freeze)
        file = file_set.original_file
        return unless file
        Riiif::Engine.routes.url_helpers.image_path(
          file.id,
          size: size
        )
      end

      def thumbnail?(_thumbnail)
        true
      end
  end
end
