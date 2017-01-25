require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { FactoryGirl.create(:account) }

  describe '.from_request' do
    let(:request) { double(host: 'example.com') }
    let(:noncanonical_request) { double(host: 'example.com.') }
    let!(:account) { described_class.create(name: 'example', tenant: 'example', cname: 'example.com') }

    it 'retrieves the account that matches the incoming request' do
      expect(described_class.from_request(request)).to eq account
    end

    it 'canonicalizes the incoming request hostname' do
      expect(described_class.from_request(noncanonical_request)).to eq account
    end
  end

  describe '#switch!' do
    let!(:old_default_index) { Blacklight.default_index }

    before do
      subject.build_solr_endpoint.update(url: 'http://example.com/solr/')
      subject.build_fcrepo_endpoint.update(url: 'http://example.com/fedora', base_path: '/dev')
      subject.build_redis_endpoint.update(namespace: 'foobaz')
      subject.switch!
    end

    after do
      subject.reset!
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

    it 'switches the Redis namespace' do
      expect(Hyrax.config.redis_namespace).to eq 'foobaz'
    end
  end

  describe '#switch' do
    let!(:previous_solr_connection) { Blacklight.default_index }
    let!(:previous_fcrepo_connection) { ActiveFedora.fedora }
    let!(:previous_redis_namespace) { 'hyku' }

    before do
      subject.build_solr_endpoint.update(url: 'http://example.com/solr/')
      subject.build_fcrepo_endpoint.update(url: 'http://example.com/fedora', base_path: '/dev')
      subject.build_redis_endpoint.update(namespace: 'foobaz')
      subject.switch!
    end

    it 'switches to the account-specific connection' do
      subject.switch do
        expect(ActiveFedora::SolrService.instance.conn.uri.to_s).to eq 'http://example.com/solr/'
        expect(ActiveFedora.fedora.host).to eq 'http://example.com/fedora'
        expect(ActiveFedora.fedora.base_path).to eq '/dev'
        expect(Hyrax.config.redis_namespace).to eq 'foobaz'
      end
    end

    it 'resets the active connections back to the defaults' do
      subject.switch do
        # no-op
      end

      expect(ActiveFedora::SolrService.instance.conn.uri.to_s).to eq 'http://127.0.0.1:8985/solr/hydra-test/'
      expect(ActiveFedora.fedora.host).to eq 'http://127.0.0.1:8986/rest'
      expect(Hyrax.config.redis_namespace).to eq previous_redis_namespace
    end
  end

  describe '#save' do
    subject { FactoryGirl.create(:sign_up_account) }

    it 'canonicalizes the account cname' do
      subject.update cname: 'example.com.'
      expect(subject.cname).to eq 'example.com'
    end
  end

  describe '#create' do
    it 'requires name when cname is absent' do
      account1 = described_class.create(tenant: 'example')
      expect(account1.errors).not_to be_empty
      expect(account1.errors.messages).to match a_hash_including(:name, :cname)
    end

    it 'does not require name when cname is present' do
      account1 = described_class.create(tenant: 'example', cname: 'example.com')
      expect(account1.errors).to be_empty
    end

    it 'builds default cname from name' do
      account1 = described_class.create(tenant: 'example', name: 'example')
      expect(account1.errors).to be_empty
      expect(account1.cname).to eq('example.dev')
    end

    it 'prevents duplicate cname and tenant values' do
      account1 = described_class.create(name: 'example', tenant: 'example', cname: 'example.dev')
      account2 = described_class.create(name: 'example', tenant: 'example', cname: 'example.dev')
      expect(account1.errors).to be_empty
      expect(account2.errors).not_to be_empty
      expect(account2.errors.messages).to match a_hash_including(:tenant, :cname)
      expect(account2.errors.messages).not_to include(:name)
    end
  end
end
