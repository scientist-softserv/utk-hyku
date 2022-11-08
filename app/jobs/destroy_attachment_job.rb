# frozen_string_literal: true

class DestroyAttachmentJob < ApplicationJob
  def perform(attachments)
    byebug
    attachments.select! { |attachment| attachment.member_of.size.zero? }
    attachments.map(&:file_sets).flatten.map(&:destroy)
    attachments.map(&:destroy)
  end
end
