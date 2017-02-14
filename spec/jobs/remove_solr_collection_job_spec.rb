RSpec.describe RemoveSolrCollectionJob do
  let(:collection) { 'x' }
  let(:connection_options) { double }
  let(:connection) { double }

  it 'destroys the solr collection' do
    expect(RSolr).to receive(:connect).with(connection_options).and_return(connection)
    expect(connection).to receive(:get).with('/solr/admin/collections',
                                             params: { action: 'DELETE', name: 'x' })
    described_class.perform_now(collection, connection_options)
  end
end
