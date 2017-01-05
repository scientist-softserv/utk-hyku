module Admin
  class GroupUsersController < ApplicationController
    layout 'admin'

    def index
      @group = Hyku::Group.find_by_id(params[:group_id])
      @users = @group.search_members(params[:q]).page(page_number).per(page_size)
      render template: 'admin/groups/users'
    end

    def add
      group = Hyku::Group.find_by_id(params[:group_id])
      users = Array.wrap(params[:user_ids])
      group.add_members_by_id(users)
      respond_to do |format|
        format.html { redirect_to admin_group_users_path(group) }
      end
    end

    def remove
      group = Hyku::Group.find_by_id(params[:group_id])
      group.remove_members_by_id(params[:id])
      respond_to do |format|
        format.html { redirect_to admin_group_users_path(group) }
      end
    end

    private
      def page_number
        params[:page].to_i || 1
      end

      def page_size
        params[:per].to_i || 10
      end
  end
end
