# frozen_string_literal: true

# OVERRIDE AllinsonFlex main: c6ec00e to add "title" as a required field
module AllinsonFlex
  module DynamicSchemaServiceDecorator
    # OVERRIDE AllinsonFlex main: c6ec00e to add "title" as a required field
    # despite whether it's in the metadata profile due to validations on models
    def required_properties
      ([:title] + property_keys.map { |prop| required_for(prop) }.compact).uniq
    end
  end
end

AllinsonFlex::DynamicSchemaService.prepend(AllinsonFlex::DynamicSchemaServiceDecorator)
