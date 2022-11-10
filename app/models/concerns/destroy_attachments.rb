# frozen_string_literal: true

module DestroyAttachments
  extend ActiveSupport::Concern
  included do
    after_destroy :destroy_attachments
  end

  def destroy_attachments
    DestroyAttachmentsJob.perform_later(member_ids) unless member_ids.empty?
  end
end
