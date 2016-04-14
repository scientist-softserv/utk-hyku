require 'rails_helper'

RSpec.describe Account, type: :model do
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
      subject.switch!
    end

    after do
      ActiveFedora::SolrService.reset!
      Blacklight.instance_variable_set(:@default_index, old_default_index)
    end

    it 'switches the ActiveFedora solr connection' do
      expect(ActiveFedora::SolrService.instance.conn.uri.to_s).to eq 'http://example.com/solr/'
    end

    it 'switches the Blacklight solr conection' do
      expect(Blacklight.default_index.uri.to_s).to eq 'http://example.com/solr/'
    end
  end

  describe '#save_and_create_tenant' do
    subject { described_class.new(tenant: 'x', cname: 'x') }

    before do
      expect(Apartment::Tenant).to receive(:create).with('x') do |&block|
        block.call
      end
    end

    it 'creates a new apartment tenant' do
      subject.save_and_create_tenant
    end

    it 'initializes the Site configuration with a link back to the Account' do
      subject.save_and_create_tenant do
        expect(Site.reload.account).to eq subject
      end
    end
  end

  describe '#solr_endpoint' do
    subject { FactoryGirl.create(:account) }

    it 'has a default solr endpoint configuration' do
      expect(subject.solr_endpoint).to be_present
      expect(subject.solr_endpoint.url).to eq SolrEndpoint.default_options[:url]
    end
  end
end
