# frozen_string_literal: true

# OVERRIDE HYRAX 3.4.1 to remove Attachment model from search results
Hyrax::FilterByType.module_eval do
  # Override this method if you want to filter for a different set of models.
  # @return [Array<Class>] a list of classes to include
  def models
    the_models = work_classes + collection_classes
    return the_models unless ['hyrax/my/works', 'hyrax/dashboard/works'].include?(blacklight_params[:controller])

    the_models - [Attachment]
  end
end
