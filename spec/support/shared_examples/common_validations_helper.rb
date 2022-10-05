# frozen_string_literal: true

RSpec.shared_examples "title validation" do |work_type|
  context 'title' do
    context 'when title is present' do
      let(:work) { build(work_type) }

      it 'is valid' do
        expect(work.valid?).to eq(true)
      end
    end

    context 'when title is nil' do
      let(:work) { build(work_type, title: nil) }

      it 'is invalid' do
        expect(work.valid?).to eq(false)
        expect(work.errors.full_messages).to include("Your work must have a title.")
      end
    end

    context 'when more than one title' do
      let(:work) { build(work_type, title: ['title 1', 'title 2']) }

      it 'is invalid' do
        expect(work.valid?).to eq(false)
        expect(work.errors.full_messages).to include("Your work can only have one title.")
      end
    end
  end
end
