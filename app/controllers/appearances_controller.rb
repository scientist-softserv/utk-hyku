class AppearancesController < ApplicationController
  before_action :set_site
  load_and_authorize_resource instance_variable: :site, class: 'Site'
  layout 'dashboard'

  # GET /sites/appearances/edit
  def edit
    add_breadcrumb t(:'hyrax.controls.home'), root_path
    add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
    add_breadcrumb t(:'hyrax.admin.sidebar.appearance'), edit_site_appearances_path
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to edit_site_appearances_path, notice: 'Appearance was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def set_site
      @site ||= Site.instance
    end

    # Whitelist of valid params
    def site_params
      params.require(:site).permit(:banner_image, :remove_banner_image)
    end
end
