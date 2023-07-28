# Keep for one reindex, starting 7/28/2023 and delete after done
Hydra::Works::WorkBehavior.module_eval do
  def ordered_works
    if ordered_members.to_a.detect {|m| m.nil?}
      logger = ActiveSupport::Logger.new('tmp/imports/bad_ordered_members.log')
      logger.error(self.id)
    end
    ordered_members.to_a.reject{|m| m.nil?}.select(&:work?)
  end
end