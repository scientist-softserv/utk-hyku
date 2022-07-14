# frozen_string_literal: true

module AllinsonFlex
  module PrependPermissionTemplatesController
    include AllinsonFlexHelper

    # override (from Hyrax 2.5.0) - extend to add :metadata_context_id
    def update_params
      params.require(:permission_template)
            .permit(:release_date, :release_period, :release_varies, :release_embargo,
                    :visibility, :workflow_id, :metadata_context_id,
                    access_grants_attributes: %i[access agent_id agent_type id])
    end

    # @return [String] the name of the current UI tab to show
    # override (from Hyrax 2.5.0) - extend to add metadata_context
    def current_tab
      if collection?
        @current_tab ||= 'sharing'
      else
        pt = params[:permission_template]
        @current_tab ||= if pt[:access_grants_attributes].present?
                           'participants'
                         elsif pt[:workflow_id].present?
                           'workflow'
                         elsif pt[:metadata_context_id].present?
                           'metadata_context'
                         else
                           'visibility'
                         end
      end
    end
  end
end

Hyrax::Admin::PermissionTemplatesController.prepend AllinsonFlex::PrependPermissionTemplatesController
