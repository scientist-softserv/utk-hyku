# frozen_string_literal: true

class DestroyAttachmentsJob < ApplicationJob
  def perform(member_ids)
    attachments = member_ids.map do |id|
      begin
        Attachment.find(id)
      rescue ActiveFedora::ModelMismatch
        nil
      end
    end.compact
    attachments.select! { |attachment| attachment.member_of.size.zero? }
    return if attachments.empty?

    attachments.map(&:file_sets).flatten.each(&:destroy)
    attachments.each(&:destroy)
  end
end
