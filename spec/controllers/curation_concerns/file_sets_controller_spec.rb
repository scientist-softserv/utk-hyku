require 'rails_helper'

RSpec.describe CurationConcerns::FileSetsController do
  describe 'show_presenter' do
    subject { described_class.show_presenter }
    it { is_expected.to eq Hybox::FileSetPresenter }
  end
end
