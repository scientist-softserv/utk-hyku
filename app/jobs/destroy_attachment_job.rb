# frozen_string_literal: true

class DestroyAttachmentJob < ApplicationJob
  def perform(member_ids)
    attachments = member_ids.map do |id|
      begin
        Attachment.find(id)
      rescue ActiveFedora::ModelMismatch
        next
      end
    end
    attachments.select! { |attachment| attachment.member_of.size.zero? }
    attachments.map(&:file_sets).flatten.each(&:destroy)
    attachments.each(&:destroy)
  end
end
