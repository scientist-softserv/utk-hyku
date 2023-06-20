# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::ConditionalDerivativeDecorator do
  let(:file_set) { double(FileSet, rdf_type: Array.wrap(rdf_type)) }
  let(:rdf_type) { nil }

  describe '.generate_derivatives_for?' do
    subject { described_class.generate_derivatives_for?(file_set: file_set) }

    context "when none of file_set's the RDF types are \"IntermediateFile\"" do
      let(:rdf_type) { ["Ketchup", "Sandwich"] }

      it { is_expected.to be_falsey }
    end

    context "when one of the file_set's RDF types for the file is \"IntermediateFile\"" do
      let(:rdf_type) { ["Ketchup", "IntermediateFile", "Sandwich"] }

      it { is_expected.to be_truthy }
    end
  end

  describe '.intermediate_file?' do
    subject { described_class.intermediate_file?(object: object) }

    context "when the rdf_type does not have the intermediate file type text" do
      context "when the object is a FileSet" do
        # I had to use a FactoryBot FileSet because the double was not catching an error
        # where file_set.try(:[], 'rdf_type_ssim') was causing an
        # ArgumentError Exception: Unknown attribute rdf_type_ssim
        # The method has been refactored since then but I thought I'd keep this here still since it's
        # sturdier than a double.
        let(:object) { create(:file_set) }

        it { is_expected.to be_falsey }
      end
    end

    context "when the rdf_type has the intermediate file type text" do
      let(:rdf_type) { ["Ketchup", "IntermediateFile", "Sandwich"] }

      context "when the object is a FileSet" do
        let(:object) { file_set }

        it { is_expected.to be_truthy }
      end

      context "when the object is a SolrDocument" do
        let(:object) { SolrDocument.new(rdf_type_ssim: rdf_type) }

        it { is_expected.to be_truthy }
      end

      context "when the object is an Attachment" do
        let(:object) { double(Attachment, rdf_type: rdf_type) }

        it { is_expected.to be_truthy }
      end
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

      it { is_expected.not_to be_valid }
    end

    context "when one of the file_set's RDF types for the file is \"IntermediateFile\"" do
      let(:rdf_type) { ["Ketchup", "IntermediateFile", "Sandwich"] }

      # TODO: Figure out why super is not calling the inherited class
      #       Hyrax::FileSetDerivativesService.new.valid? method
      xit { is_expected.to be_valid }
    end
  end

  it "is included in the Hyrax::FileSetDerivativesService modules" do
    expect(Hyrax::FileSetDerivativesService.included_modules).to include(described_class)
  end
end
