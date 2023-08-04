# frozen_string_literal: true

# Keep for one reindex, starting 7/28/2023 and delete after done
Hydra::Works::WorkBehavior.module_eval do
  def ordered_works
    if ordered_members.to_a.detect(&:nil?)
      logger = ActiveSupport::Logger.new('tmp/imports/bad_ordered_members.log')
      logger.error(id)
    end
    ordered_members.to_a.reject(&:nil?).select(&:work?)
  end
end
