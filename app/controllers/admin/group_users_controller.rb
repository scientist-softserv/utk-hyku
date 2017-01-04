module Admin
  class GroupUsersController < ApplicationController
    layout 'admin'

    def index
      @group = Hyku::Group.find_by_id(params[:group_id])
      @users = User.page(page_number).per(page_size)
      render template: 'admin/groups/users'
    end

    def add
    end

    def remove
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
