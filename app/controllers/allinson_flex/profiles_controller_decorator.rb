# frozen_string_literal: true

# OVERRIDE allinson_flex 1.0 to redirect the user with a warning if
# they manually visit the new or edit url paths

module AllinsonFlex
  module ProfilesControllerDecorator
    # GET /allinson_flex_profiles/new
    def new
      if ENV['DISPLAY_ALLINSON_FLEX_UI'] == 'true'
        add_breadcrumbs
        add_breadcrumb 'New'
        @allinson_flex_profile = AllinsonFlex::Profile.new

        @allinson_flex_profile.profile_classes.build
        @allinson_flex_profile.profile_contexts.build
        @allinson_flex_profile.properties.build.texts.build
      else
        redirect_to profiles_path, alert: 'Create a Profile by uploading a new one'
      end
    end

    # GET /allinson_flex_profiles/1/edit
    def edit
      if ENV['DISPLAY_ALLINSON_FLEX_UI'] == 'true'
        add_breadcrumbs
        add_breadcrumb 'Edit'

        @allinson_flex_profile = AllinsonFlex::Profile.current_version
        # auto update date on save
        @allinson_flex_profile.profile['profile']['date_modified'] = Time.zone.today.strftime('%Y-%m-%d')
        @allinson_flex_profile.update(locked_by_id: current_user.id, locked_at: Time.zone.now)
      else
        redirect_to profiles_path, alert: 'Edit a Profile by uploading a new one'
      end
    end
  end
end

AllinsonFlex::ProfilesController.prepend(AllinsonFlex::ProfilesControllerDecorator)
