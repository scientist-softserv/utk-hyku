module Admin
  class GroupsController < AdminController
    before_action :load_group, only: [:edit, :update, :destroy]

    def index
      @groups = Hyku::Group.search(params[:q]).page(page_number).per(page_size)
    end

    def new
      @group = Hyku::Group.new
    end

    def create
      new_group = Hyku::Group.new(new_group_params)
      if new_group.save
        redirect_to admin_groups_path, notice: "#{new_group.name} created"
      elsif new_group.invalid?
        redirect_to new_admin_group_path, alert: 'Groups must have a name'
      else
        logger.error('Valid Hyku::Group could not be created')
        redirect_to new_admin_group_path, flash: { error: 'Group could not be created.' }
      end
    end

    def edit
    end

    def update
      if @group.save
        redirect_to admin_groups_path, notice: "#{@group.name} updated"
      elsif @group.invalid?
        redirect_to edit_admin_group_path(@group), alert: "#{@group.name} is invalid and could not be updated."
      else
        logger.error("Valid Hyku::Group id:#{@group.id} could not be updated")
        redirect_to edit_admin_group_path(@group), flash: { error: "#{@group.name} could not be updated." }
      end
    end

    def destroy
      if @group.destroy
        redirect_to admin_groups_path, notice: "#{@group.name} destroyed"
      else
        logger.error("Hyku::Group id:#{@group.id} could not be destroyed")
        redirect_to admin_groups_path flash: { error: "#{@group.name} could not be destroyed" }
      end
    end

    private
      def load_group
        @group = Hyku::Group.find_by_id(params[:id])
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
