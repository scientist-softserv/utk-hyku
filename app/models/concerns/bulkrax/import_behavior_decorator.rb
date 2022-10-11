# frozen_string_literal: true

# OVERRIDE 4.3.0 to account for allinson flex loading
module Bulkrax
  module ImportBehaviorDecorator
    def build_for_importer
      # Ensure loading of all flexible metadata properties
      factory_class&.new
      super
    end
  end
end

Bulkrax::ImportBehavior.prepend(Bulkrax::ImportBehaviorDecorator)
