# Called in 'object_factory'
module Importer
  class AttachFilesToWork < AttachFilesToWorkJob
    # Overrides hyrax/app/jobs/attach_files_to_work_job because
    # the original `perform` method iterates through an array of files and gives a NoMethod Error `each`
    def perform(work, uploaded_file, actor)
      actor.file_set.permissions_attributes = work.permissions.map(&:to_hash)
      actor.create_metadata
      actor.create_content(uploaded_file)
      actor.attach_to_work(work)
      uploaded_file.update(file_set_uri: actor.file_set.uri)
    end
  end
end
