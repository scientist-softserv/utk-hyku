module CurationConcerns
  class GenericWorkShowPresenter < Sufia::WorkShowPresenter
    self.file_presenter_class = Hyku::FileSetPresenter

    def manifest_url
      manifest_helper.polymorphic_url([:manifest, self])
    end

    private

      def manifest_helper
        @manifest_helper ||= ManifestHelper.new(request.base_url)
      end
  end
end
