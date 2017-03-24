class SitesController < ApplicationController
  before_action :set_site
  load_and_authorize_resource
  layout 'dashboard'
end
