# frozen_string_literal: true

# OVERRIDE allinson_flex 1.0 to redirect the user with a warning if
# they manually visit the new or edit url paths

module AllinsonFlex
  module ProfilesControllerDecorator
    # GET /allinson_flex_profiles/new
    def new
      redirect_to profiles_path, alert: 'Create a Profile by uploading a new one' if AllinsonFlex::Profile.any?
    end

    # GET /allinson_flex_profiles/1/edit
    def edit
      redirect_to profiles_path, alert: 'Edit a Profile by uploading a new one' if AllinsonFlex::Profile.any?
    end
  end
end

AllinsonFlex::ProfilesController.prepend(AllinsonFlex::ProfilesControllerDecorator)
