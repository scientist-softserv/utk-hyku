# frozen_string_literal: true

class ReindexWorksJob < ApplicationJob
  def perform(work = nil)
    if work.present?
      work.update_index
    else
      Hyrax.config.registered_curation_concern_types.each do |work_type|
        work_type.constantize.find_each do |w|
          ReindexWorksJob.perform_later(w)
        end
      end
    end
  end
end
