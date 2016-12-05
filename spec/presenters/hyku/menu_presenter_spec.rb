require 'rails_helper'

RSpec.describe Hyku::MenuPresenter do
  let(:instance) { described_class.new(context) }
  let(:context) { double }

  describe "#settings_section?" do
    before do
      allow(context).to receive(:controller_name).and_return(controller_name)
    end
    subject { instance.settings_section? }
    context "for the ContentBlocksController" do
      let(:controller_name) { ContentBlocksController.controller_name }
      it { is_expected.to be true }
    end
  end
end
