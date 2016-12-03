module Admin
  class UsersController < ApplicationController
    before_action :ensure_admin!
    include Hyrax::UsersControllerBehavior
    layout 'admin'

    def self.local_prefixes
      ['hyrax/users']
    end

    private

      def ensure_admin!
        # Even though the user can view this admin set, they may not be able to view
        # it on the admin page.
        authorize! :read, :admin_dashboard
      end

      def deny_access(_exception)
        redirect_to main_app.root_url, alert: "You are not authorized to view this page"
      end
  end
end
