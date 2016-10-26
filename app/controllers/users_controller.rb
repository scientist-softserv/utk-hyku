class UsersController < ApplicationController
  include Sufia::UsersControllerBehavior
  layout 'admin'
end
