# frozen_string_literal: true

## OVERRIDE HYRAX 3.4.1 to correct method spelling that causes sidekiq errors.

Hyrax::VisibilityPropagator::NullVisibilityPropogator.class_eval do
  ## OVERRIDE HYRAX 3.4.1 to correct method spelling that causes sidekiq errors.
  # @return [void]
  # @raise [RuntimeError] if we're in development mode
  def propagate
    # rubocop:disable Performance/Caller
    message = "Tried to propagate visibility to members of #{source} " \
                "but didn't know what kind of object it is. Model " \
                "name #{source.try(:model_name)}. Called from #{caller[0]}."
    # rubocop:enable Performance/Caller

    Hyrax.logger.warn(message)
    Rails.env.development? ? raise(message) : :noop
  end
end