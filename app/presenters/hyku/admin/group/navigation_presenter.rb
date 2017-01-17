module Hyku
  module Admin
    module Group
      class NavigationPresenter
        attr_accessor :action, :controller, :group_id

        def initialize(params:)
          @params = params
          @action = params.fetch(:action)
          @controller = params.fetch(:controller)
          @group_id = params.fetch(group_id_key)
        end

        def tabs
          [
            OpenStruct.new({
              name: I18n.t('hyku.admin.groups.nav.attributes'),
              controller: 'admin/groups',
              action: 'edit',
              path: Rails.application.routes.url_helpers.edit_admin_group_path(group_id)
            }),
            OpenStruct.new({
              name: I18n.t('hyku.admin.groups.nav.members'),
              controller: 'admin/group_users',
              action: 'index',
              path: Rails.application.routes.url_helpers.admin_group_users_path(group_id)
            }),
            OpenStruct.new({
              name: I18n.t('hyku.admin.groups.nav.delete'),
              controller: 'admin/groups',
              action: 'remove',
              path: Rails.application.routes.url_helpers.remove_admin_group_path(group_id)
            })
          ]
        end

        private

          def params
            @params
          end

          def group_id_key
            return :id if params.has_key?(:id)
            return :group_id if params.has_key?(:group_id)
            :key_not_found
          end
      end
    end
  end
end
