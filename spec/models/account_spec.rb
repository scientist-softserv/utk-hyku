require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '.from_request' do
    let(:request) { double(host: 'example.com') }
    let!(:account) { described_class.create(tenant: 'example', cname: 'example.com') }

    it 'retrieves the account that matches the incoming request' do
      expect(described_class.from_request(request)).to eq account
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
end
