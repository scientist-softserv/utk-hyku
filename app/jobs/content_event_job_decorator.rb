# frozen_string_literal: true

# OVERRIDE Hyrax 3.x - Override log_user_event to avoid calling on nil user
# Hyrax::Collections::CollectionMemberService.add_members_by_ids expects a user,
# which defaults to nil when called by the deprecated add_members method
# which is used in Bulkrax's CreateRelationships job.
module ContentEventJobDecorator
  # log the event to the users profile stream
  def log_user_event(depositor)
    depositor&.log_profile_event(event)
  end
end

ContentEventJob.prepend(ContentEventJobDecorator)
