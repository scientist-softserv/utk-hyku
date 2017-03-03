module Admin
  class GroupUsersController < AdminController
    before_action :load_group

    def index
      @users = @group.search_members(params[:q]).page(page_number).per(page_size)
      render template: 'admin/groups/users'
    end

    def add
      @group.add_members_by_id(params[:user_ids])
      respond_to do |format|
        format.html { redirect_to admin_group_users_path(@group) }
      end
    end

    def remove
      @group.remove_members_by_id(params[:user_ids])
      respond_to do |format|
        format.html { redirect_to admin_group_users_path(@group) }
      end
    end

    private

      def load_group
        @group = Hyku::Group.find_by(id: params[:group_id])
      end

      def page_number
        params.fetch(:page, 1).to_i
      end

      def page_size
        params.fetch(:per, 10).to_i
      end
  end
end
