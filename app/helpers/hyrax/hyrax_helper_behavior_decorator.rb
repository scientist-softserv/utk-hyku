# frozen_string_literal: true

module Hyrax
  # Decorator for Hyrax 3.4.1
  #
  # @note In addition to this file, you'll need to revisit ./app/views/hyrax/admin/analytics/work_reports/show.html.erb
  #
  # @see https://github.com/samvera/hyrax/pull/5819 for original source.
  # @see app/helpers/application_helper.rb for module inclusion
  module HyraxHelperBehaviorDecorator
    ##
    # @param value [Object] the thing we'll attempt to cast to a formatted date.
    # @param format [String] the `DateTime.strftime` format string
    # @return [String]
    #
    # @see https://github.com/samvera/hyrax/issues/5818
    # @see https://ruby-doc.org/core-3.0.1/Time.html#method-i-strftime
    # @note OVERRIDE for Hyrax 3.4.1
    def cast_to_date_time_format(value, format:)
      return value.strftime(format) if value.respond_to(:strftime)

      Time.zone.parse(value).strftime(format)
    rescue ArgumentError, TypeError
      value.to_s
    end

    # Used by the gallery view
    #
    # @note This method was initially overridden in 2.5.1, revisited and still relevant for 3.4.1.  It
    # was consolidated into this file from ./app/helpers/hyrax/override_helper_behavior.rb
    def collection_thumbnail(_document, _image_options = {}, _url_options = {})
      return super if Site.instance.default_collection_image.blank?

      image_tag(Site.instance.default_collection_image&.url)
    end

    # @param [ActionController::Parameters] params first argument for Blacklight::SearchState.new
    # @param [Hash] facet
    # @note Ignores all but the first facet.  Probably a bug.
    #
    # @note This method was initially overridden in 2.5.1, revisited and still relevant for 3.4.1.  It
    # was consolidated into this file from ./app/helpers/hyrax/override_helper_behavior.rb
    def search_state_with_facets(params, facet = {})
      state = Blacklight::SearchState.new(params, CatalogController.blacklight_config)
      return state.params if facet.none?
      state.add_facet_params("#{facet.keys.first}_sim",
                             facet.values.first)
    end
  end
end

## Why not the following prepend behavior?  Because we're amending a module which appears to not
## quite work with our playbook
## (https://playbook-staging.notch8.com/en/dev/ruby/decorators-and-class-eval)
# Hyrax::HyraxHelperBehavior.prepend(HyraxHelperBehaviorDecorator)
