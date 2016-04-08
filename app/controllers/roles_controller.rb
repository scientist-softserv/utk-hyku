##
# CRUD actions for assigning exhibit roles to
# existing users
class RolesController < ApplicationController
  load_and_authorize_resource :user, parent: false

  before_action do
    authorize! :manage, Role
  end

  def index
  end

  def update
    if @user.update(user_params)
      redirect_to site_roles_path, notice: notice
    else
      render action: 'index'
    end
  end

  protected

    def user_params
      params.require(:user).permit(global_roles: [])
    end
end
