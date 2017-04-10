module Hyku
  # view-model for the admin menu
  class MenuPresenter < Hyrax::MenuPresenter
    # TODO: This has been moved to Hyrax and can be removed in the next update
    delegate :can?, to: :view_context

    # Returns true if the current controller happens to be one of the controllers that deals
    # with settings.  This is used to keep the parent section on the sidebar open.
    def settings_section?
      %w(appearances content_blocks labels features).include?(controller_name)
    end

    # Returns true if the current controller happens to be one of the controllers that deals
    # with roles and permissions.  This is used to keep the parent section on the sidebar open.
    def roles_and_permissions_section?
      # we're using a case here because we need to differentiate UsersControllers
      # in different namespaces (Hyrax & Admin)
      case controller
      when ::Admin::UsersController, ::Admin::GroupsController
        true
      else
        false
      end
    end

    # Returns true if the current controller happens to be one of the controllers that deals
    # with repository activity  This is used to keep the parent section on the sidebar open.
    def repository_activity_section?
      %w(admin dashboard status).include?(controller_name)
    end

    # TODO: This has been moved to Hyrax and can be removed in the next update
    # Returns true if the current controller happens to be one of the controllers that deals
    # with user activity  This is used to keep the parent section on the sidebar open.
    def user_activity_section?
      # we're using a case here because we need to differentiate UsersControllers
      # in different namespaces (Hyrax & Admin)
      case controller
      when Hyrax::UsersController, Hyrax::NotificationsController, Hyrax::TransfersController
        true
      else
        false
      end
    end

    # TODO: This has been moved to Hyrax and can be refactored to call super
    # Returns true if we ought to show the user the 'Configuration' section
    # of the menu
    def show_configuration?
      can?(:manage, Site) ||
        can?(:create, Sipity::WorkflowResponsibility) ||
        can?(:manage, User) ||
        can?(:manage, Hyku::Group)
    end
  end
end
