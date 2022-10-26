# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileSet do
  subject { FileSet.new }

  it { is_expected.to respond_to(:rdf_type) }

  context "#rdf_type" do
    let(:given_rdf_type) { Hyrax::CreateDerivativesJobDecorator::PRESERVATION_FILE }
    let(:work) { create(:attachment_with_one_file, rdf_type: [given_rdf_type]) }

    it "is the parent works #rdf_type" do
      file_set = work.file_sets.first

      expect(file_set.rdf_type).to eq(given_rdf_type)
    end
  end
end
