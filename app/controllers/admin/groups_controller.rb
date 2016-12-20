module Admin
  class GroupsController < ApplicationController
    before_action :ensure_admin!
    layout 'admin'

    def self.local_prefixes
      ['hyku/groups']
    end

    private

      def ensure_admin!
        authorize! :read, :admin_dashboard
      end

      def deny_access(_exception)
        redirect_to main_app.root_url, alert: "You are not authorized to view this page"
      end
  end
end
