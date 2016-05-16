module Importer
  module Factory
    class CollectionFactory < ObjectFactory
      self.klass = Collection
      self.system_identifier_field = :identifier

      def find_or_create
        collection = find
        return collection if collection
        run(&:save!)
      end

      def attach_files
        # nop
      end
    end
  end
end
