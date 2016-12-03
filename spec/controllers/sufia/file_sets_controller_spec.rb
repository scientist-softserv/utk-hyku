require 'rails_helper'

RSpec.describe Sufia::FileSetsController do
  describe 'show_presenter' do
    subject { described_class.show_presenter }
    it { is_expected.to eq Hyku::FileSetPresenter }
  end
end
