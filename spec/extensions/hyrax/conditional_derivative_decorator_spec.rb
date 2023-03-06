# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::ConditionalDerivativeDecorator do
  let(:file_set) { double(FileSet, rdf_type: Array.wrap(rdf_type)) }
  let(:rdf_type) { nil }

  describe '.generate_derivatives_for?' do
    subject { described_class.generate_derivatives_for?(file_set: file_set) }

    context "when none of file_set's the RDF types are \"IntermediateFile\"" do
      let(:rdf_type) { ["Ketchup", "Sandwich"] }

      it { is_expected.to be_truthy }
    end

    context "when one of the file_set's RDF types for the file is \"IntermediateFile\"" do
      let(:rdf_type) { ["Ketchup", "IntermediateFile", "Sandwich"] }

      it { is_expected.to be_falsey }
    end
  end

  describe "mixing in module to base class" do
    subject { model.new(file_set: file_set) }

    let(:model) do
      Class.new do
        def initialize(file_set:)
          @file_set = file_set
        end
        attr_reader :file_set
        include Hyrax::ConditionalDerivativeDecorator
      end
    end

    context "when none of file_set's the RDF types are \"IntermediateFile\"" do
      let(:rdf_type) { ["Ketchup", "Sandwich"] }

      it { is_expected.to be_valid }
    end

    context "when one of the file_set's RDF types for the file is \"IntermediateFile\"" do
      let(:rdf_type) { ["Ketchup", "IntermediateFile", "Sandwich"] }

      it { is_expected.not_to be_valid }
    end
  end

  it "is included in the Hyrax::FileSetDerivativesService modules" do
    expect(Hyrax::FileSetDerivativesService.included_modules).to include(described_class)
  end
end
