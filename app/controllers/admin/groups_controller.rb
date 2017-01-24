module Admin
  class GroupsController < AdminController
    before_action :load_group, only: [:edit, :update, :remove, :destroy]

    def index
      @groups = Hyku::Group.search(params[:q]).page(page_number).per(page_size)
    end

    def new
      @group = Hyku::Group.new
    end

    def create
      new_group = Hyku::Group.new(group_params)
      if new_group.save
        redirect_to admin_groups_path, notice: t('hyku.admin.groups.flash.create.success', group: new_group.name)
      elsif new_group.invalid?
        redirect_to new_admin_group_path, alert: t('hyku.admin.groups.flash.create.invalid')
      else
        redirect_to new_admin_group_path, flash: { error: t('hyku.admin.groups.flash.create.failure') }
      end
    end

    def edit; end

    def update
      if @group.update(group_params)
        redirect_to admin_groups_path, notice: t('hyku.admin.groups.flash.update.success', group: @group.name)
      else
        redirect_to edit_admin_group_path(@group), flash: {
          error: t('hyku.admin.groups.flash.update.failure', group: @group.name)
        }
      end
    end

    def remove; end

    def destroy
      if @group.destroy
        redirect_to admin_groups_path, notice: t('hyku.admin.groups.flash.destroy.success', group: @group.name)
      else
        logger.error("Hyku::Group id:#{@group.id} could not be destroyed")
        redirect_to admin_groups_path flash: { error: t('hyku.admin.groups.flash.destroy.failure', group: @group.name) }
      end
    end

    private

      def load_group
        @group = Hyku::Group.find_by(id: params[:id])
      end

      def group_params
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
