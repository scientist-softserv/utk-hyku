# frozen_string_literal: true

class SetDefaultParentThumbnailJob < ApplicationJob
  queue_as :import

  def perform(child_work:, parent_work:)
    parent_work.reload
    return if parent_work.thumbnail.is_a?(Attachment)

    parent_work.representative = child_work
    parent_work.thumbnail = child_work
    parent_work.save
  end
end
