RSpec.describe ContentBlockHelper, type: :helper do
  describe '#displayable_content_block' do
    it 'is defined' do
      expect(helper).to respond_to(:displayable_content_block)
    end

    subject { helper.displayable_content_block(content_block, options) }
    let(:options) { {} }
    context 'when a block has a nil value' do
      let(:content_block) { double(value: nil) }
      it { is_expected.to be_nil }
    end
    context 'when a block has an empty string value' do
      let(:content_block) { double(value: '') }
      it { is_expected.to be_nil }
    end
    context 'when a block has a non-empty string value' do
      let(:content_block) { double(value: value) }
      let(:value) { '<p>foobarbaz</p>' }
      it { is_expected.to eq "<div>#{value}</div>" }
      context 'with options' do
        let(:options) { { id: 'my_id', class: 'huge' } }
        it { is_expected.to eq "<div id=\"my_id\" class=\"huge\">#{value}</div>" }
      end
    end
  end
end
