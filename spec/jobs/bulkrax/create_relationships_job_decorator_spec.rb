# frozen_string_literal: true

require 'rails_helper'

module Bulkrax
  module Jobs
    RSpec.describe CreateRelationshipsJobDecorator, type: :job do
      let(:job) { CreateRelationshipsJob.new.extend(CreateRelationshipsJobDecorator) }
      let(:parent_work) { create(:video) }
      let(:child_work) { create(:attachment_with_one_file) }
      let(:job_class) { class_double('ActiveJob::Base') }

      before do
        # A bit of a code smell but I couldn't find a better way around it.
        # This does require us to know the details of Bulkrax::Jobs::CreateRelationshipsJob#add_to_work.
        # Without setting @child_members_added, we get a NoMethodError, undefined method `<<' for nil:NilClass
        # Ref: https://github.com/samvera-labs/bulkrax/blob/ae05be9a0dd7fa95d260069c5274c816e24293bd/app/jobs/bulkrax/create_relationships_job.rb#L171
        job.instance_variable_set(:@child_members_added, [])
        allow(SetDefaultParentThumbnailJob).to receive(:set).with(wait: 5.minutes).and_return(job_class)
      end

      describe '#set_default_parent_thumbnail' do
        context 'when the child is an intermediate file' do
          it 'calls SetDefaultParentThumbnailJob' do
            allow(child_work).to receive(:intermediate_file?).and_return(true)

            expect(job_class).to receive(:perform_later).with(child_work: child_work, parent_work: parent_work)
            job.add_to_work(child_work, parent_work)
          end
        end

        context 'when the child is not an intermediate file' do
          it 'does not call SetDefaultParentThumbnailJob' do
            allow(child_work).to receive(:intermediate_file?).and_return(false)

            expect(job_class).not_to receive(:perform_later)
            job.add_to_work(child_work, parent_work)
          end
        end
      end
    end
  end
end
