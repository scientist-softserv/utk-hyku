class StatusController < ApplicationController
  layout 'admin'

  before_action do
    authorize! :read, :admin_dashboard
  end

  def index
  end
end
