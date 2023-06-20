# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SetDefaultParentThumbnailJob, type: :job do
  let(:parent_work) { create(:pdf) }
  let(:child_work) { create(:attachment_with_one_file, title: ['Child work Page 001']) }
  let(:child_work_no_file_set) { create(:attachment, title: ['Child work Page 001']) }

  describe '.perform' do
    it 'sets a thumbnail on the parent if there is not one already' do
      expect(parent_work.thumbnail).not_to eq(child_work)

      described_class.perform_now(
        child_work: child_work,
        parent_work: parent_work
      )

      parent_work.reload
      expect(parent_work.thumbnail).to eq(child_work)
    end

    it 'returns early if parent work already has a thumbnail' do
      parent_work.thumbnail = create(:attachment, title: ['A previous Attachment'])
      parent_work.save

      expect do
        described_class.perform_now(
          child_work: child_work,
          parent_work: parent_work
        )
      end.not_to(change { parent_work.reload.thumbnail.id })
    end
  end
end
