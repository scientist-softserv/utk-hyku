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
      expect(Blacklight.default_index.uri.to_s).to eq 'http://example.com/solr/'
    end
  end
end
