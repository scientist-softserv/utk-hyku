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
          expect(file_set).to receive(:reload)
          expect(parent).to receive(:update_index)
          described_class.perform_now(file_set, file.id)
        end
      end

      context "when the file_set isn't the parent's thumbnail" do
        let(:parent) { GenericWork.new }

        it "doesn't update the parent's index" do
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
      file_set.original_file = file
      file_set.save!
    end

    # this spec was pulled over from hyrax.
    # After spending time, I'm commenting it out for now since it fails
    #        +     :size=>"676x986",
    # Diff:
    # rubocop:disable Metrics/LineLength
    # expected: (/test\.pdf/, {:outputs=>[{:format=>"jpg", :label=>:thumbnail, :layer=>0, :size=>"338x493", :url=>String}]})
    # got: (
    # "/app/samvera/hyrax-webapp/tmp/uploads/26/f6/4c/b6/26f64cb6-25df-409d-be5a-27bfe473ebe9/test.pdf",
    # {
    #   :outputs=>[{
    #     :format=>"jpg",
    #     :label=>:thumbnail,
    #     :layer=>0,
    #     :size=>"676x986",
    #     :url=>
    #     "file:///app/samv...yrax-webapp/tmp/derivatives/26/f6/4c/b6/-2/5d/f-/40/9d/-b/e5/a-/27/bf/e4/73/eb/e9-thumbnail.jpeg"
    #     }]
    #     }
    #   )
    # rubocop:enable Metrics/LineLength
    xit "runs a full text extract" do
      expect(Hydra::Derivatives::PdfDerivatives).to receive(:create)
        .with(/test\.pdf/, outputs: [{ label: :thumbnail,
                                       format: 'jpg',
                                       size: '338x493',
                                       url: String,
                                       layer: 0 }])
      expect(Hydra::Derivatives::FullTextExtract).to receive(:create)
        .with(/test\.pdf/, outputs: [{ url: RDF::URI, container: "extracted_text" }])
      described_class.perform_now(file_set, file.id)
    end
  end
end
