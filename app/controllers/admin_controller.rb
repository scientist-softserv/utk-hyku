class AdminController < ApplicationController
  before_action :ensure_admin!
  layout 'dashboard'

  private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end

    def deny_access(_exception)
      redirect_to main_app.root_url, alert: t('hyku.admin.flash.access_denied')
    end
end
