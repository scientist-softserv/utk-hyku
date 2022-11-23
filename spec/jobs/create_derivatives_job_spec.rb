# frozen_string_literal: true

RSpec.describe CreateDerivativesJob do
  around do |example|
    ffmpeg_enabled = Hyrax.config.enable_ffmpeg
    Hyrax.config.enable_ffmpeg = true
    example.run
    Hyrax.config.enable_ffmpeg = ffmpeg_enabled
  end

  let(:parent) { create(:attachment, rdf_type: ['']) }

  before do
    allow(file_set).to receive(:parent_works).and_return([parent])
  end

  context "with an audio file" do
    let(:id)       { '123' }
    let(:file_set) { FileSet.new }

    let(:file) do
      Hydra::PCDM::File.new.tap do |f|
        f.content = 'foo'
        f.original_name = 'picture.png'
        f.save!
      end
    end

    before do
      allow(FileSet).to receive(:find).with(id).and_return(file_set)
      allow(file_set).to receive(:id).and_return(id)
      allow(file_set).to receive(:mime_type).and_return('audio/x-wav')
    end

    context "with a file name" do
      it 'calls create_derivatives and save on a file set' do
        allow(file_set).to receive(:rdf_type).and_return(['http://pcdm.org/use#IntermediateFile'])
        expect(Hydra::Derivatives::AudioDerivatives).to receive(:create)
        expect(file_set).to receive(:reload)
        expect(file_set).to receive(:update_index)
        described_class.perform_now(file_set, file.id)
      end
    end

    context 'with a parent object' do
      before do
        allow(file_set).to receive(:parent).and_return(parent)
        # Stub out the actual derivative creation
        allow(file_set).to receive(:create_derivatives)
      end

      context 'when the file_set is the thumbnail of the parent' do
        let(:parent) { GenericWork.new(thumbnail_id: id) }

        it 'updates the index of the parent object' do
          allow(file_set).to receive(:rdf_type).and_return(['http://pcdm.org/use#IntermediateFile'])
          expect(file_set).to receive(:reload)
          expect(parent).to receive(:update_index)
          described_class.perform_now(file_set, file.id)
        end
      end

      context "when the file_set isn't the parent's thumbnail" do
        let(:parent) { GenericWork.new }

        it "doesn't update the parent's index" do
          allow(file_set).to receive(:rdf_type).and_return(['http://pcdm.org/use#IntermediateFile'])
          expect(file_set).to receive(:reload)
          expect(parent).not_to receive(:update_index)
          described_class.perform_now(file_set, file.id)
        end
      end

      context "when the parent's rdf_type is PreservationFile" do
        let(:parent) { create(:attachment, rdf_type: ['http://pcdm.org/use#PreservationFile']) }

        before do
          allow(file_set).to receive(:parent_works).and_return([parent])
        end

        it "does not call #create_derivatives on the file set" do
          expect(file_set).not_to receive(:create_derivatives)
          described_class.perform_now(file_set, file.id)
        end
      end

      context "when the parent's rdf_type is PreservationFile and IntermediateFile" do
        let(:parent) do
          create(:attachment, rdf_type:
            ['http://pcdm.org/use#PreservationFile', 'http://pcdm.org/use#IntermediateFile'])
        end

        before do
          allow(file_set).to receive(:parent_works).and_return([parent])
        end

        it "does call #create_derivatives on the file set" do
          expect(file_set).to receive(:reload)
          expect(file_set).to receive(:create_derivatives)
          described_class.perform_now(file_set, file.id)
        end
      end

      context "when the parent's rdf_type is PreservationFile and IntermediateFile" do
        let(:parent) do
          create(:attachment, rdf_type:
            ['http://pcdm.org/use#PreservationFile', 'http://pcdm.org/use#IntermediateFile'])
        end

        before do
          allow(file_set).to receive(:parent_works).and_return([parent])
        end

        it "does call #create_derivatives on the file set" do
          expect(file_set).to receive(:reload)
          expect(file_set).to receive(:create_derivatives)
          described_class.perform_now(file_set, file.id)
        end
      end
    end
  end

  context "with a pdf file" do
    let(:file_set) { create(:file_set) }

    let(:file) do
      Hydra::PCDM::File.new do |f|
        f.content = File.open(File.join(fixture_path, "hyrax/hyrax_test4.pdf"))
        f.original_name = 'test.pdf'
        f.mime_type = 'application/pdf'
      end
    end

    before do
      allow(file_set).to receive(:rdf_type).and_return(['http://pcdm.org/use#IntermediateFile'])
      file_set.original_file = file
      file_set.save!
    end

    it "runs a full text extract" do
      # the size is different than in Hyrax because of file_set_derivatives_overrides.rb
      expect(Hydra::Derivatives::PdfDerivatives).to receive(:create)
        .with(/test\.pdf/, outputs: [{ label: :thumbnail,
                                       format: 'jpg',
                                       size: '676x986',
                                       url: String,
                                       layer: 0 }])
      expect(Hydra::Derivatives::FullTextExtract).to receive(:create)
        .with(/test\.pdf/, outputs: [{ url: RDF::URI, container: "extracted_text" }])
      described_class.perform_now(file_set, file.id)
    end
  end
end
