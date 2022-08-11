# frozen_string_literal: true

module AllinsonFlex
  module PrependAdminSetForm
    # override (from Hyrax 2.5.0) - new method to add metadata_context
    def metadata_context
      @metadata_context ||= model.metadata_context
    end
  end
end
