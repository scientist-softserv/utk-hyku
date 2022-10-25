# frozen_string_literal: true
## OVERRIDE HYRAX 3.4.1 to correct method spelling that causes sidekiq errors.

module Hyrax
  ##
  # @abstract Propagates visibility from a provided object (e.g. a Work) to some
  #   group of its members (e.g. file_sets).
  module VisibilityPropagatorDecorator
    ## OVERRIDE HYRAX 3.4.1 to correct method spelling that causes sidekiq errors.
    # @return [void]
    # @raise [RuntimeError] if we're in development mode
    def propagate
      message =  "Tried to propagate visibility to members of #{source} " \
                  "but didn't know what kind of object it is. Model " \
                  "name #{source.try(:model_name)}. Called from #{caller[0]}."

      Hyrax.logger.warn(message)
      Rails.env.development? ? raise(message) : :noop
    end
  end
end

Hyrax::VisibilityPropagator.prepend(Hyrax::VisibilityPropagatorDecorator)