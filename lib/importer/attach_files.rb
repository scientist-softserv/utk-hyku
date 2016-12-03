module Importer
  class AttachFiles
    def self.run(work, files_directory, file_name)
      AttachFiles.new(work, files_directory, file_name).run
    end

    attr_reader :work, :files_directory, :file_names

    def initialize(work, files_directory, file_names)
      @work = work
      @files_directory = files_directory
      @file_names = file_names
    end

    def run
      # only attach files once
      return if work.file_sets.count > 0
      file_names.each do |file_path|
        create_file(file_path)
      end
    end

    private

      def create_file(file_name)
        path = file_path(file_name)
        unless File.exist?(path)
          Rails.logger.error "  * File doesn't exist at #{path}"
          return
        end

        actor = Hyrax::Actors::FileSetActor.new(FileSet.new, User.batch_user)
        actor.create_metadata(work)
        actor.create_content(File.new(path))
      end

      def file_path(file_name)
        File.join(files_directory, file_name)
      end
  end
end
