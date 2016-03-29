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

    it 'creates a new apartment tenant' do
      expect(Apartment::Tenant).to receive(:create).with('x')
      subject.save_and_create_tenant
    end
  end
end
