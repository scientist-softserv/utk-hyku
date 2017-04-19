# Monkey-patch around outdated Hyrax knowledge, assuming CarrierWave::Storage::Fog is present
class AttachFilesToWorkJob < ActiveJob::Base
  private

    # @param [Hyrax::Actors::FileSetActor] actor
    # @param [UploadedFileUploader] file
    def attach_content(actor, file)
      case file.file
      when CarrierWave::SanitizedFile
        actor.create_content(file.file.to_file)
      when CarrierWave::Storage::AWSFile # only this line is different from upstream
        import_url(actor, file)
      else
        raise ArgumentError, "Unknown type of file #{file.class}"
      end
    end
end
