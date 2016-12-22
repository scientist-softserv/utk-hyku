module Admin
  class GroupUsersController < ApplicationController
    layout 'admin'

    def index
      @group = Hyku::Group.find_by_id(params[:group_id])
      @users = Array.wrap(User.first)
      render template: 'admin/groups/users'
    end

    def add
    end

    def remove
    end
  end
end
