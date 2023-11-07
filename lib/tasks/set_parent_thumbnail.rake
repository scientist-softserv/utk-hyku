# frozen_string_literal: true

require 'ruby-progressbar'

namespace :hyku do
  namespace :update do
    desc 'Make sure all works have a thumbnail'
    task :set_parent_thumbnail, [:accounts] => [:environment] do |t, args|
      accounts = if args[:accounts].present?
                   args[:accounts].split(',').map { |a| Account.find_by(name: a.strip) }.compact
                 else
                   Account.all
                 end
      accounts.each do |account|
        begin
          switch!(account.cname)
          puts "********************** switched to #{account.cname} **********************"
          Hyrax.config.curation_concerns.each do |cc|
            next if cc.count.zero?
            next if cc == Attachment
            puts "********************** checking #{cc}s **********************"
            title = "~ #{account.name} - #{cc}"
            progressbar = ProgressBar.create(total: cc.count, title: title, format: "%t %c of %C %a %B %p%%")

            cc.find_each do |work|
              progressbar.increment

              next if work.thumbnail.is_a?(Attachment)

              work.representative = work.works.find(&:intermediate_file?) if work.representative_id.blank?
              work.thumbnail = work.works.find(&:intermediate_file?) if work.thumbnail_id.blank?
              work.save
            end
            puts "********************** updated #{cc}s **********************"
          end
        rescue StandardError => e
          puts "********************** error: #{e} **********************"
          next
        end
      end
    end
  end
end
