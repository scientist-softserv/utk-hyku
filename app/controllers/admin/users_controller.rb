module Admin
  class UsersController < AdminController
    include Hyrax::UsersControllerBehavior

    def self.local_prefixes
      ['hyrax/users']
    end

    private

      def deny_access(_exception)
        redirect_to main_app.root_url, alert: t('hyku.admin.flash.access_denied')
      end
  end
end
