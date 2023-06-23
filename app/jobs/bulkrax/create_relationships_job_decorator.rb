# frozen_string_literal: true

# OVERRIDE IIIF Print v1.0.0 to call SetDefaultParentThumbnailJob

module Bulkrax
  module Jobs
    module CreateRelationshipsJobDecorator
      def add_to_work(child_record, parent_record)
        super
        set_default_parent_thumbnail(child_record, parent_record) if child_record&.intermediate_file?
      end

      def set_default_parent_thumbnail(child_record, parent_record)
        ::SetDefaultParentThumbnailJob.set(wait: 5.minutes)
                                      .perform_later(child_work: child_record, parent_work: parent_record)
      end
    end
  end
end

Bulkrax::Jobs::CreateRelationshipsJob.prepend(Bulkrax::Jobs::CreateRelationshipsJobDecorator)
