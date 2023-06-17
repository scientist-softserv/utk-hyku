# frozen_string_literal: true

# OVERRIDE IIIF Print v1.0.0 to call SetDefaultParentThumbnailJob

module IiifPrint
  module Jobs
    module CreateRelationshipsJobDecorator
      def add_to_work(child_record:, parent_record:)
        return true if parent_record.ordered_members.to_a.include?(child_record)

        set_default_parent_thumbnail(child_record, parent_record) if child_record&.intermediate_file?

        parent_record.ordered_members << child_record
        @parent_record_members_added = true
      end

      def set_default_parent_thumbnail(child_record, parent_record)
        return unless first_page?(child_record.title.first)

        ::SetDefaultParentThumbnailJob.set(wait: 5.minutes)
                                      .perform_later(child_work: child_record, parent_work: parent_record)
      end

      def first_page?(title)
        title.match(/Page\s0*1\Z/)
      end
    end
  end
end

IiifPrint::Jobs::CreateRelationshipsJob.prepend(IiifPrint::Jobs::CreateRelationshipsJobDecorator)
