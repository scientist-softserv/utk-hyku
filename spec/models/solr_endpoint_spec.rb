require 'rails_helper'

RSpec.describe SolrEndpoint do
  subject { described_class.new url: 'http://example.com/solr/' }

  describe '#connection_options' do
    it 'merges the model attributes with the application settings' do
      expect(subject.connection_options).to include url: 'http://example.com/solr/', read_timeout: 120
    end
  end

  describe '#connection' do
    it 'initializes an RSolr connection with the model options' do
      expect(subject.connection).to be_a_kind_of RSolr::Client
      expect(subject.connection.uri.to_s).to eq 'http://example.com/solr/'
    end
  end

  describe '#ping' do
    let(:mock_connection) { double(options: {}) }
    before do
      allow(RSolr).to receive(:connect).and_return(mock_connection)
    end
    it 'checks if the service is up' do
      allow(mock_connection).to receive(:get).with('admin/ping').and_return('status' => 'OK')
      expect(subject.ping).to be_truthy
    end

    it 'is false if the service is down' do
      allow(mock_connection).to receive(:get).with('admin/ping').and_raise(RSolr::Error::Http.new(nil, nil))
      expect(subject.ping).to eq false
    end
  end
end
