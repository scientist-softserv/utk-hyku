require 'rails_helper'

RSpec.describe ContentBlock, type: :model do
  before do
    create(:content_block,
           name: ContentBlock::ABOUT,
           value: '<h1>About Page</h1>')
  end

  describe '.about_page' do
    subject { described_class.about_page.value }
    it { is_expected.to eq '<h1>About Page</h1>' }
  end

  describe '.about_page=' do
    let(:new_about) { '<h2>Foobarfoo</h2>' }
    it 'sets a new about_page' do
      described_class.about_page = new_about
      expect(described_class.about_page.value).to eq new_about
    end
  end
end
