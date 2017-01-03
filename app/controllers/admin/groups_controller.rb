module Admin
  class GroupsController < ApplicationController
    before_action :ensure_admin!
    layout 'admin'

    def index
      @groups = Hyku::Group.page(page_number).per(page_size)
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
        logger.error('Hyku::Group could not be created')
        flash.now[:error] = 'Group could not be created'
        redirect_to admin_groups_path
      end
    end

    def edit
      @group = Hyku::Group.find_by_id(params[:id])
    end

    def update
      group = Hyku::Group.find_by_id(params[:id])
      if group.save
        flash.now[:notice] = "#{group.name} updated"
        redirect_to admin_groups_path
      else
        logger.error('Hyku::Group failed to update')
        flash.now[:error] = 'Group failed to update'
        redirect_to admin_groups_path
      end
    end

    def remove
      @group = Hyku::Group.find_by_id(params[:id])
    end

    def destroy
      group = Hyku::Group.find_by_id(params[:id])
      if group.destroy
        flash.now[:notice] = "#{group.name} destroyed"
        redirect_to admin_groups_path
      else
        logger.error('Hyku::Group could not be destroyed')
        flash.now[:error] = 'Group could not be destroyed'
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

      def page_number
        params[:page].to_i || 1
      end

      def page_size
        params[:per].to_i || 10
      end
  end
end
