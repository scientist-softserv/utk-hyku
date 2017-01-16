class SplashController < ApplicationController
  skip_before_action :require_active_account!

  layout "multitenant"

  def index; end
end
