# frozen_string_literal: true

module Hyrax
  # This decorator is used to override logic bug found in Hyrax v3.5.0
  module AdminSetCreateServiceDecorator
    # Find default AdministrativeSet using saved id
    # @return [Hyrax::AdministrativeSet] the default admin set; nil if id not saved
    # @raise [RuntimeError] if an admin set with the saved id doesn't exist
    def find_default_admin_set
      id = default_admin_set_id
      return if id.blank?
      Hyrax.query_service.find_by(id: id)
    rescue Valkyrie::Persistence::ObjectNotFoundError
      # The default ID is DEFAULT_ID when saving is not supported.  It is ok
      # for this default id to be known but not found.  The admin set will be
      # created with DEFAULT_ID by find_or_create_default_admin_set.

      # This decorator is used to override logic bug found in Hyrax v3.4.2
      return if save_default?

      # id is saved in the default_admin_set_persister's table but doesn't exist
      # NOTE: This is a corrupt state and shouldn't happen.  Manual intervention
      #       is required to determine the correct value for the default admin
      #       set id.  The saved id either needs to be updated to the correct
      #       value or deleted to allow a new default admin set to be found
      #       (i.e. an admin set with id DEFAULT_ID) or generated.
      raise "Corrupt default admin set.  Persisted admin set with saved default_admin_set_id doesn't exist."
    end
  end
end