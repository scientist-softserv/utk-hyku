# frozen_string_literal: true

class ReindexWorksJob < ApplicationJob
  def perform(work = nil)
    if work.present?
      work.update_index
    else
      Hyrax.config.registered_curation_concern_types.each do |work_type|
        work_type.constantize.find_each(&:update_index)
      end
    end
  end
end
