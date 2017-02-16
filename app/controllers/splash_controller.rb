class SplashController < ApplicationController
  skip_before_action :require_active_account!

  layout "proprietor"

  def index; end
end
