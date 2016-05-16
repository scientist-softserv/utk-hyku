require 'importer'
module Stanford
  module Importer
    class PurlImporter
      class_attribute :parser_class
      self.parser_class = Stanford::Importer::PurlParser

      def initialize(files_directory, druids = [])
        @files_directory = files_directory
        @druids = druids
      end

      def import_all
        count = 0
        @druids.each do |druid|
          import(druid)
          count += 1
        end
        count
      end

      def import(druid)
        Rails.logger.info "Importing: #{druid}"
        parser = parser_class.new(retrieve(druid))
        create_fedora_objects(parser.model, parser.attributes)
      end

      # Select a factory to create the objects in fedora.
      # For example, if we are importing a MODS record for an
      # image, the ModsParser will return an Image model, so
      # we'll select the ImageFactory to create the fedora
      # objects.
      def create_fedora_objects(model, attributes)
        ::Importer::Factory.for(model.to_s).new(attributes, @files_directory, files(attributes)).run
      end

      # @param [Hash] attributes the attribuutes from the parser
      # @return [Array] a list of file names to import
      def files(attributes)
        attributes[:files]
      end

      private

        def retrieve(druid)
          conn.get("/#{druid}.xml").body
        end

        def conn
          @conn ||= Faraday.new(url: 'https://purl.stanford.edu')
        end
    end
  end
end
