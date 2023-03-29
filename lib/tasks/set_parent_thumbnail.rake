# frozen_string_literal: true

namespace :hyku do
  namespace :update do
    desc 'Make sure all works have a thumbnail'
    task set_parent_thumbnail: [:environment] do
      Account.find_each do |account|
        begin
          switch!(account.cname)
          puts "********************** switched to #{account.cname} **********************"
          Hyrax.config.curation_concerns.each do |cc|
            next if cc.count.zero?

            puts "********************** checking #{cc}s **********************"
            parent_work_ids = []

            cc.find_each do |parent_work|
              next if parent_work.thumbnail

              parent_work.child_works.each do |child_work|
                next unless child_work.is_a? Attachment
                next if parent_work.thumbnail
                  child_work_thumbnail = child_work.file_sets.first
                  parent_work.representative = child_work_thumbnail if parent_work.representative_id.blank?
                  parent_work.thumbnail = child_work_thumbnail if parent_work.thumbnail_id.blank?
                  # pdf = child_work.file_sets.select { |f| f.label.match(/.pdf/) }.first
                  parent_work.update_attributes!(rendering_ids: [child_work_thumbnail.id]) #if pdf.present?
                  parent_work.save
                  parent_work_ids << parent_work.id
              end

            end
            puts "********************** Parent Thumbnails Set for the following work ids: **********************"
            puts "********************** #{ parent_work_ids } **********************"
          end
        rescue StandardError => e
          puts "********************** error: #{e} **********************"
          next
        end
      end
    end
  end
end
