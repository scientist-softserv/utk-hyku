IiifPrint.config do |config|
  # NOTE: WorkTypes and models are used synonymously here.
  # Add models to be excluded from search so the user
  # would not see them in the search results.
  # by default, use the human readable versions like:
  # @example
  #   # config.excluded_model_name_solr_field_values = ['Generic Work', 'Image']
  #
  config.excluded_model_name_solr_field_values = ['Attachment']

  # Add configurable solr field key for searching,
  # default key is: 'human_readable_type_sim'
  # if another key is used, make sure to adjust the
  # config.excluded_model_name_solr_field_values to match
  # @example
  #   config.excluded_model_name_solr_field_key = 'some_solr_field_key'

  # Configure how the manifest sorts the canvases, by default it sorts by :title,
  # but a different model property may be desired such as :date_published
  # @example
  #   config.sort_iiif_manifest_canvases_by = :date_published

  config.default_iiif_manifest_version = 3

  config.child_work_attributes_function = lambda do |parent_work:, admin_set_id:|
    {
      admin_set_id: admin_set_id.to_s,
      visibility: parent_work.visibility.to_s,
      is_child: true,
      rdf_type: ["http://pcdm.org/IntermediateFile"]
    }
  end
end
