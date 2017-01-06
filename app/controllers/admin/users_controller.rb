module Admin
  class UsersController < AdminController
    include Hyrax::UsersControllerBehavior

    def self.local_prefixes
      ['hyrax/users']
    end
  end
end
