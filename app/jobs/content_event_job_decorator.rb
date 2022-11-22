# frozen_string_literal: true

# OVERRIDE HYRAX 3.4.1 to handle nil case and casue of sidekiq sentry error
# TODO: why is depositor coming across as nil?
module ContentEventJobDecorator
  # OVERRIDE HYRAX 3.4.1 to handle nil case and casue of sidekiq sentry error
  # log the event to the users profile stream
  def log_user_event(depositor)
    depositor&.log_profile_event(event)
  end
end

ContentEventJob.prepend(ContentEventJobDecorator)
