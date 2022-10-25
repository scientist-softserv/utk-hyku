# frozen_string_literal: true

# OVERRIDE HYRAX 3.4.1 to remove Attachment model from search results
module Hyrax
  module FilterByTypeDecorator
    # Override this method if you want to filter for a different set of models.
    # @return [Array<Class>] a list of classes to include
    def models
      the_models = super
      return the_models unless ['catalog', 'hyrax/my/works'].include?(blacklight_params[:controller])
      the_models - [Attachment]
    end
  end
end

Hyrax::FilterByType.prepend(Hyrax::FilterByTypeDecorator)
