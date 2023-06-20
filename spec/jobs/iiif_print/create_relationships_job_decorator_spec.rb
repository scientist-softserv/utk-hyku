# frozen_string_literal: true

require 'rails_helper'

module IiifPrint
  module Jobs
    RSpec.describe CreateRelationshipsJobDecorator, type: :job do
      let(:job) { CreateRelationshipsJob.new }
      let(:parent_work) { create(:pdf) }
      let(:child_work_page_1) { create(:attachment_with_one_file, title: ['Child work Page 001']) }
      let(:child_work_page_2) { create(:attachment_with_one_file, title: ['Child work Page 002']) }

      describe '#set_default_parent_thumbnail' do
        it 'does not get called when the child is not an intermediate file' do
          allow(child_work_page_1).to receive(:intermediate_file?).and_return(false)

          job.extend(CreateRelationshipsJobDecorator)

          expect(job).not_to receive(:set_default_parent_thumbnail)

          job.add_to_work(child_record: child_work_page_1, parent_record: parent_work)
        end

        it 'gets called when the child is an intermediate file' do
          allow(child_work_page_1).to receive(:intermediate_file?).and_return(true)

          job_class = class_double('ActiveJob::Base')

          expect(SetDefaultParentThumbnailJob).to receive(:set).with(wait: 5.minutes).and_return(job_class)
          expect(job_class).to receive(:perform_later).with(child_work: child_work_page_1, parent_work: parent_work)

          job.add_to_work(child_record: child_work_page_1, parent_record: parent_work)
        end

        it 'does not get called when the child is not the first page' do
          allow(child_work_page_2).to receive(:intermediate_file?).and_return(true)

          expect(SetDefaultParentThumbnailJob).not_to receive(:set)
          expect(SetDefaultParentThumbnailJob).not_to receive(:perform_later)

          job.add_to_work(child_record: child_work_page_2, parent_record: parent_work)
        end
      end
    end
  end
end
