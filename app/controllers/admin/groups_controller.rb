module Admin
  class GroupsController < ApplicationController
    before_action :ensure_admin!
    layout 'admin'

    def index
      @groups = Hyku::Group.all
    end

    def new
      @group = Hyku::Group.new
    end

    def create
      new_group = Hyku::Group.new(new_group_params)
      if new_group.save
        flash.now[:notice] = "#{new_group.name} created"
        redirect_to admin_groups_path
      else
        logger.error('Hyku::Group failed to save')
        flash.now[:error] = 'Group failed to save'
        redirect_to admin_groups_path
      end
    end

    private

      def deny_access(_exception)
        redirect_to main_app.root_url, alert: "You are not authorized to view this page"
      end

      def ensure_admin!
        authorize! :read, :admin_dashboard
      end

      def new_group_params
        params.require(:hyku_group).permit(:name, :description)
      end
  end
end
