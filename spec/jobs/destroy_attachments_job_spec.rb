# frozen_string_literal: true

RSpec.describe DestroyAttachmentsJob, type: :job do
  let(:work) { FactoryBot.create(:generic_work_with_one_attachment) }

  it 'gets called when a work is destroyed' do
    expect(described_class).to receive(:perform_later).with(work.member_ids).once
    work.destroy
  end

  describe '#perform' do
    before do
      work.destroy
    end

    let(:run_job) { described_class.perform_now(work.member_ids) }

    context 'with one Attachment child work' do
      it 'deletes the Attachment' do
        expect { run_job }.to change(Attachment, :count).by(-1)
      end

      it 'deletes the FileSet of the Attachment' do
        expect { run_job }.to change(FileSet, :count).by(-1)
      end
    end

    context 'with multiple Attachments' do
      let(:work) { FactoryBot.create(:generic_work_with_two_attachments) }

      it 'deletes all Attachments' do
        expect { run_job }.to change(Attachment, :count).by(-2)
      end

      it 'deletes all FileSets of the Attachments' do
        expect { run_job }.to change(FileSet, :count).by(-2)
      end
    end

    context 'with two works that have the same Attachment' do
      let(:another_work) { FactoryBot.create(:generic_work) }

      it 'will not delete the Attachment if a parent still exists' do
        another_work.ordered_members << work.members.first
        another_work.save

        expect { run_job }.not_to change(Attachment, :count)
      end
    end

    context 'with one Attachment and a non-Attachment' do
      let(:work) { FactoryBot.create(:generic_work_with_one_attachment_and_one_image) }

      it 'will only delete the Attachment and leave the non-Attachment' do
        expect { run_job }.to change(Attachment, :count).by(-1).and change(Image, :count).by(0)
      end
    end
  end
end
