require 'rails_helper'

RSpec.describe 'curation_concerns/base/_representative_media' do
  let(:solr_doc) { double(representative_id: file_set.id) }
  let(:pres) { Sufia::WorkShowPresenter.new(solr_doc, nil) }
  let(:file_set) { FileSet.create! { |fs| fs.apply_depositor_metadata('atz') } }

  before do
    Hydra::Works::AddFileToFileSet.call(file_set,
                                        File.open(fixture_path + '/images/world.png'),
                                        :original_file)
    render 'curation_concerns/base/representative_media', presenter: pres
  end

  it 'has a IIIF link' do
    expect(rendered).to have_link 'IIIF'
  end
end
