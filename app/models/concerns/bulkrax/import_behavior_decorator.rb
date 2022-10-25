# frozen_string_literal: true

# OVERRIDE 4.3.0 to account for allinson flex loading
module Bulkrax
  module ImportBehaviorDecorator
    def build_for_importer
      # Ensure loading of all flexible metadata properties
      factory_class&.new
      super
    end

    # Don't assign rights statement if nothing is defined
    def add_rights_statement
      return unless parser.parser_fields['rights_statement'].present? && (
        override_rights_statement || parsed_metadata['rights_statement'].blank?
      )

      parsed_metadata['rights_statement'] = [parser.parser_fields['rights_statement']]
    end
  end
end

Bulkrax::ImportBehavior.prepend(Bulkrax::ImportBehaviorDecorator)
