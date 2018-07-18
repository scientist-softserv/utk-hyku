require 'importer/log_subscriber'
module Importer
  module Factory
    class ObjectFactory
      extend ActiveModel::Callbacks
      define_model_callbacks :save, :create
      class_attribute :klass, :system_identifier_field
      attr_reader :attributes, :files_directory, :object

      def initialize(attributes, files_dir = nil)
        @attributes = attributes
        @files_directory = files_dir
      end

      def run
        arg_hash = { id: attributes[:id], name: 'UPDATE', klass: klass }
        @object = find
        if @object
          ActiveSupport::Notifications.instrument('import.importer', arg_hash) { update }
        else
          ActiveSupport::Notifications.instrument('import.importer', arg_hash.merge(name: 'CREATE')) { create }
        end
        yield(object) if block_given?
        object
      end

      ## FOR CONSIDERATION: handle a row (i.e. Work) with more than one file:
      def update
        raise "Object doesn't exist" unless object
        @attr = update_attributes
        run_callbacks(:save) do
          work_actor.update(environment(@attr))
        end
        replace_existing_file_set if object.file_sets.present?
        # attach_file_to_work
        log_updated(object)
      end

      def create_attributes
        transform_attributes
      end

      def update_attributes
        transform_attributes.except(:id)
      end

      def find
        return find_by_id if attributes[:id]
        return search_by_identifier if attributes[system_identifier_field].present?
        raise "Missing identifier: Unable to search for existing object without " \
          "either fedora ID or #{system_identifier_field}"
      end

      def find_by_id
        klass.find(attributes[:id]) if klass.exists?(attributes[:id])
      end

      def search_by_identifier
        query = { Solrizer.solr_name(system_identifier_field, :symbol) =>
                    attributes[system_identifier_field] }
        klass.where(query).first
      end

      # An ActiveFedora bug when there are many habtm <-> has_many associations means they won't all get saved.
      # https://github.com/projecthydra/active_fedora/issues/874
      # 2+ years later, still open!
      def create
        @attr = create_attributes
        @object = klass.new
        run_callbacks :save do
          run_callbacks :create do
            klass == Collection ? create_collection(@attr) : work_actor.create(environment(@attr))
          end
        end
        # attach_file_to_work
        log_created(object)
      end

      def log_created(obj)
        msg = "Created #{klass.model_name.human} #{obj.id}"
        Rails.logger.info("#{msg} (#{Array(attributes[system_identifier_field]).first})")
      end

      def log_updated(obj)
        msg = "Updated #{klass.model_name.human} #{obj.id}"
        Rails.logger.info("#{msg} (#{Array(attributes[system_identifier_field]).first})")
      end

      private

        # @param [Hash] attrs the attributes to put in the environment
        # @return [Hyrax::Actors::Environment]
        def environment(attrs)
          Hyrax::Actors::Environment.new(@object, Ability.new(User.batch_user), attrs)
        end

        def work_actor
          Hyrax::CurationConcern.actor
        end

        def create_collection(attrs)
          @object.attributes = attrs
          @object.apply_depositor_metadata(User.batch_user)
          @object.save!
        end

        # Override if we need to map the attributes from the parser in
        # a way that is compatible with how the factory needs them.
        def transform_attributes
          StringLiteralProcessor.process(attributes.slice(*permitted_attributes))
                                .merge(file_attributes)
        end

        def upload_id
          return [] if object.blank?
          Hyrax::UploadedFile.where(file_set_uri: "#{object.file_sets.first.uri}").ids
        end

        def file_attributes
          hash = {}
          if files_directory.present? && attributes[:file].present?
            imported_file = [import_file(file_paths.first)]
            hash[:files] = imported_file
            hash[:uploaded_files] = upload_id
          end
          hash
        end

        def file_paths
          attributes[:file].map { |file_name| File.join(files_directory, file_name) } if attributes[:file]
        end

        def import_file(path)
          u = Hyrax::UploadedFile.new
          u.user_id = User.find_by_user_key(User.batch_user_key).id if User.find_by_user_key(User.batch_user_key)
          u.file = CarrierWave::SanitizedFile.new(path)
          u.save
          u
        end

        ## If no file name is provided in the CSV file, `attach_file_to_work` is not performed
        ## TO DO: handle invalid file in CSV
        ## currently the importer stops if no file corresponding to a given file_name is found
        # def attach_file_to_work
        #   imported_file = [import_file(file_paths.first)] if file_paths
        #   AttachFilesToWorkJob.new.perform(object, imported_file, @attr) if imported_file
        # end

        def replace_existing_file_set
          f = object.file_sets.first
          f.destroy if attributes[:file] != f.title
        end

        # Regardless of what the MODS Parser gives us, these are the properties we are prepared to accept.
        def permitted_attributes
          klass.properties.keys.map(&:to_sym) + %i[id edit_users edit_groups read_groups visibility]
        end
    end
  end
end
