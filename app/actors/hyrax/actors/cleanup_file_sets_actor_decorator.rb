# frozen_string_literal: true

module Hyrax
  module Actors
    module CleanupFileSetsActorDecorator
      private

        def cleanup_file_sets(curation_concern)
          fs = curation_concern.file_sets
          attachments = curation_concern.members
                                        .select { |member| member.is_a? Attachment }
                                        .select { |attachment| attachment.member_of.size == 1 }
          curation_concern.list_source.destroy
          if attachments.size.positive?
            attachments.each do |attachment|
              cleanup_file_sets(attachment)
              attachment.destroy
            end
          end
          Hyrax::SolrService.delete(curation_concern.id)
          fs.each(&:destroy) if fs.size.positive?
        end
    end
  end
end

Hyrax::Actors::CleanupFileSetsActor.prepend(Hyrax::Actors::CleanupFileSetsActorDecorator)
