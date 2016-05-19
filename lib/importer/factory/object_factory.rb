require 'importer/log_subscriber'
module Importer
  module Factory
    class ObjectFactory
      extend ActiveModel::Callbacks
      define_model_callbacks :save, :create
      after_save :attach_files

      class_attribute :klass, :attach_files_service, :system_identifier_field

      attr_reader :attributes, :files_directory, :object, :files

      def initialize(attributes, files_dir = nil, files = [])
        @files_directory = files_dir
        @files = files
        @attributes = attributes
      end

      # rubocop:disable Metrics/MethodLength
      def run
        # rubocop:disable Lint/AssignmentInCondition
        if @object = find
          ActiveSupport::Notifications.instrument('import.importer',
                                                  id: attributes[:id], name: 'UPDATE', klass: klass) do
            update
          end
        else
          ActiveSupport::Notifications.instrument('import.importer',
                                                  id: attributes[:id], name: 'CREATE', klass: klass) do
            create
          end
        end
        # rubocop:enable Lint/AssignmentInCondition

        yield(object) if block_given?
        object
      end
      # rubocop:enable Metrics/MethodLength

      def update
        raise "Object doesn't exist" unless object
        object.attributes = update_attributes
        run_callbacks(:save) do
          object.save!
        end
        log_updated(object)
      end

      def create_attributes
        transform_attributes
      end

      def update_attributes
        transform_attributes.except(:id)
      end

      def attach_files
        return unless files_directory.present? && files.present?

        attach_files_service.run(object, files_directory, files)
        object.save! # Save the association with the attached files.
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

      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def create
        attrs = create_attributes

        # There's a bug in ActiveFedora when there are many
        # habtm <-> has_many associations, where they won't all get saved.
        # https://github.com/projecthydra/active_fedora/issues/874
        @object = klass.new
        run_callbacks :save do
          run_callbacks :create do
            if klass == Collection
              @object.attributes = attrs
              @object.apply_depositor_metadata(User.batchuser)
              @object.save!
            else
              work_actor = CurationConcerns::CurationConcern.actor(@object, User.batchuser)
              work_actor.create(attrs)
            end
          end
        end

        log_created(object)
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

      def log_created(obj)
        Rails.logger.info(
          "Created #{klass.model_name.human} #{obj.id} (#{Array(attributes[system_identifier_field]).first})")
      end

      def log_updated(obj)
        Rails.logger.info(
          "Updated #{klass.model_name.human} #{obj.id} (#{Array(attributes[system_identifier_field]).first})")
      end

      private

        # Override if we need to map the attributes from the parser in
        # a way that is compatible with how the factory needs them.
        def transform_attributes
          StringLiteralProcessor.process(attributes.slice(*permitted_attributes))
        end

        # Regardless of what the MODS Parser gives us, these are the properties
        # we are prepared to accept.
        def permitted_attributes
          klass.properties.keys.map(&:to_sym) +
            [:id, :edit_users, :edit_groups, :read_groups, :visibility]
        end
    end
  end
end
