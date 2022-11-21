# frozen_string_literal: true

RSpec.describe Hyrax::Actors::CleanupFileSetsActor do
  subject { middleware.destroy(env) }

  let(:work) { FactoryBot.create(:generic_work_with_one_attachment) }
  let(:depositor) { create(:user) }
  let(:ability) { ::Ability.new(depositor) }
  let(:attributes) { {} }
  let(:env) { Hyrax::Actors::Environment.new(work, ability, attributes) }
  let(:terminator) { Hyrax::Actors::Terminator.new }
  let(:middleware) do
    ActionDispatch::MiddlewareStack.new.tap do |middleware|
      middleware.use described_class
    end.build(terminator)
  end

  describe "#destroy" do
    before do
      work
    end

    context 'when a work has a FileSet' do
      let(:work) { FactoryBot.create(:generic_work_with_one_file) }

      it 'removes all file sets' do
        expect { subject }.to change(FileSet, :count).by(-1)
      end
    end

    context 'with one Attachment child work' do
      it 'deletes the Attachment' do
        expect { subject }.to change(Attachment, :count).by(-1)
      end

      it 'deletes the FileSet of the Attachment' do
        expect { subject }.to change(FileSet, :count).by(-1)
      end
    end

    context 'with multiple Attachments' do
      let(:work) { FactoryBot.create(:generic_work_with_two_attachments) }

      it 'deletes all Attachments' do
        expect { subject }.to change(Attachment, :count).by(-2)
      end

      it 'deletes all FileSets of the Attachments' do
        expect { subject }.to change(FileSet, :count).by(-2)
      end
    end

    context 'with two works that have the same Attachment' do
      let(:another_work) { FactoryBot.create(:generic_work) }

      it 'will not delete the Attachment if a parent still exists' do
        another_work.ordered_members << work.members.first
        another_work.save

        expect { subject }.not_to change(Attachment, :count)
      end
    end

    context 'with one Attachment and a non-Attachment' do
      let(:work) { FactoryBot.create(:generic_work_with_one_attachment_and_one_image) }

      it 'will only delete the Attachment and leave the non-Attachment' do
        expect { subject }.to change(Attachment, :count).by(-1).and change(Image, :count).by(0)
      end
    end
  end
end
