require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { FactoryGirl.create(:account) }

  describe '.from_request' do
    let(:request) { double(host: 'example.com') }
    let!(:account) { described_class.create(tenant: 'example', cname: 'example.com') }

    it 'retrieves the account that matches the incoming request' do
      expect(described_class.from_request(request)).to eq account
    end
  end

  describe '#switch!' do
    let!(:old_default_index) { Blacklight.default_index }

    before do
      subject.build_solr_endpoint.update(url: 'http://example.com/solr/')
      subject.build_fcrepo_endpoint.update(url: 'http://example.com/fedora', base_path: '/dev')
      subject.switch!
    end

    after do
      ActiveFedora::SolrService.reset!
      ActiveFedora::Fedora.reset!
      Blacklight.instance_variable_set(:@default_index, old_default_index)
    end

    it 'switches the ActiveFedora solr connection' do
      expect(ActiveFedora::SolrService.instance.conn.uri.to_s).to eq 'http://example.com/solr/'
    end

    it 'switches the ActiveFedora fcrepo connection' do
      expect(ActiveFedora.fedora.host).to eq 'http://example.com/fedora'
      expect(ActiveFedora.fedora.base_path).to eq '/dev'
    end

    it 'switches the Blacklight solr conection' do
      expect(Blacklight.connection_config[:url]).to eq 'http://example.com/solr/'
    end
  end

  describe '#switch' do
    let!(:previous_solr_connection) { Blacklight.default_index }
    let!(:previous_fcrepo_connection) { ActiveFedora.fedora }

    before do
      subject.build_solr_endpoint.update(url: 'http://example.com/solr/')
      subject.build_fcrepo_endpoint.update(url: 'http://example.com/fedora', base_path: '/dev')
      subject.switch!
    end

    it 'switches to the account-specific connection' do
      subject.switch do
        expect(ActiveFedora::SolrService.instance.conn.uri.to_s).to eq 'http://example.com/solr/'
        expect(ActiveFedora.fedora.host).to eq 'http://example.com/fedora'
        expect(ActiveFedora.fedora.base_path).to eq '/dev'
      end
    end

    it 'resets the active connections back to the defaults' do
      subject.switch do
        # no-op
      end

      expect(ActiveFedora::SolrService.instance.conn.uri.to_s).to eq 'http://127.0.0.1:8985/solr/hydra-test/'
      expect(ActiveFedora.fedora.host).to eq 'http://127.0.0.1:8986/rest'
    end
  end
end
