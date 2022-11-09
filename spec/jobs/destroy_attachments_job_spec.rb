# frozen_string_literal: true

RSpec.describe DestroyAttachmentsJob, type: :job do
  let(:attachment) { FactoryBot.create(:attachment_with_one_file) }
  let(:work) { FactoryBot.create(:generic_work) }

  before do
    allow(work).to receive(:member_ids).and_return([attachment.id])
  end

  it 'calls the job' do
    expect(described_class).to receive(:perform_later).with([attachment.id]).once
    work.destroy
  end

  describe '#perform' do
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
      let(:another_attachment) { FactoryBot.create(:attachment_with_one_file) }

      before do
        allow(work).to receive(:member_ids).and_return([attachment.id, another_attachment.id])
      end

      it 'deletes all Attachments' do
        expect { run_job }.to change(Attachment, :count).by(-2)
      end

      it 'deletes all FileSets of the Attachments' do
        expect { run_job }.to change(FileSet, :count).by(-2)
      end
    end
  end
end
