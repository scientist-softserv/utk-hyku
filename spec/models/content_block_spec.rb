RSpec.describe ContentBlock, type: :model do
  describe '.default_scope' do
    subject { described_class.about_page.site }
    it 'has an associated Site' do
      is_expected.to eq Site.instance
    end
  end

  context "the about page" do
    before do
      create(:content_block,
             name: ContentBlock::ABOUT,
             value: '<h1>About Page</h1>')
    end

    describe 'getter' do
      subject { described_class.about_page.value }
      it { is_expected.to eq '<h1>About Page</h1>' }
    end

    describe 'setter' do
      let(:new_about) { '<h2>Foobarfoo</h2>' }
      it 'sets a new about_page' do
        described_class.about_page = new_about
        expect(described_class.about_page.value).to eq new_about
      end
    end
  end

  context "the help page" do
    before do
      create(:content_block,
             name: ContentBlock::HELP,
             value: '<h1>Help Page</h1>')
    end

    describe 'getter' do
      subject { described_class.help_page.value }
      it { is_expected.to eq '<h1>Help Page</h1>' }
    end

    describe 'setter' do
      let(:new_help) { '<h2>Foobarfoo</h2>' }
      it 'sets a new help_page' do
        described_class.help_page = new_help
        expect(described_class.help_page.value).to eq new_help
      end
    end
  end
end
