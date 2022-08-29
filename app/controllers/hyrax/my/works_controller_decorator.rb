# frozen_string_literal: true

# OVERRIDE Hyrax 3.4.1 to hide and substitute Add Work button for AllinsonFlex

module Hyrax
  module My
    module WorksControllerDecorator
      def index
        # The user's collections for the "add to collection" form
        @user_collections = collections_service.search_results(:deposit)
        # OVERRIDE begins
        @allinson_flex_profile = AllinsonFlex::Profile&.current_version
        # OVERRIDE ends

        add_breadcrumb t(:'hyrax.controls.home'), root_path
        add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
        add_breadcrumb t(:'hyrax.admin.sidebar.works'), hyrax.my_works_path
        managed_works_count
        @create_work_presenter = create_work_presenter_class.new(current_user)
        super
      end
    end
  end
end

Hyrax::My::WorksController.prepend(Hyrax::My::WorksControllerDecorator)
