require 'rails_helper'

RSpec.describe RedisEndpoint do
  let(:namespace) { 'foobar' }
  describe '.options' do
    subject { described_class.new namespace: namespace }

    it 'uses the configured application settings' do
      expect(subject.options[:namespace]).to eq namespace
    end
  end
end
