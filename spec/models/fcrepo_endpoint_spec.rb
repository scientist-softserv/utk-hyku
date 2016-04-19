require 'rails_helper'

RSpec.describe FcrepoEndpoint do
  subject { described_class.new url: 'http://example.com/fedora/rest/' }

  describe '.default_options' do
    it 'uses the configured application settings' do
      expect(described_class.default_options).to include(:url, :base_path)
    end
  end
end
