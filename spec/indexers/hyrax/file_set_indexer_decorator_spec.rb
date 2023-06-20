# frozen_string_literal: true

RSpec.describe Hyrax::FileSetIndexerDecorator, type: :decorator do
  let(:rdf_type) { ['http://pcdm.org/use#IntermediateFile'] }
  let(:work) do
    work = build(:attachment, rdf_type: rdf_type)
    file_set = FactoryBot.build(:file_set, :image, title: ['A Contained FileSet'], label: 'world.png')
    work.ordered_members << file_set
    work.save
    work
  end

  let(:file_set) { work.file_sets.first }
  let(:indexer) { Hyrax::FileSetIndexer.new(file_set) }

  it 'includes rdf_type_ssim' do
    solr_doc = indexer.generate_solr_document
    expect(solr_doc['rdf_type_ssim']).to eq rdf_type
  end
end
