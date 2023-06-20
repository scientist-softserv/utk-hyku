# frozen_string_literal: true

RSpec.describe Hyrax::FileSetPresenterDecorator, type: :decorator do
  let(:solr_document) { double('SolrDocument') }
  let(:ability) { double('Ability') }
  let(:presenter) { Hyrax::FileSetPresenter.new(solr_document, ability) }

  describe '#intermediate_file?' do
    it 'delegates to the solr_document' do
      expect(solr_document).to receive(:intermediate_file?)
      presenter.intermediate_file?
    end
  end
end
