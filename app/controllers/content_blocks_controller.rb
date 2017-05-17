class ContentBlocksController < SitesController
  # GET /sites/1/edit
  def edit
    add_breadcrumb t(:'hyrax.controls.home'), root_path
    add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
    add_breadcrumb t(:'hyrax.admin.sidebar.content_blocks'), edit_site_content_blocks_path
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to edit_site_content_blocks_path, notice: 'Site was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_params
      params.require(:site).permit(:announcement_text,
                                   :marketing_text,
                                   :featured_researcher,
                                   :about_page,
                                   :help_page)
    end
end
