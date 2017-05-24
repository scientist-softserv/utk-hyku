require 'spec_helper'

RSpec.describe Collection do
  it "is a hyrax collection" do
    expect(described_class.ancestors).to include Hyrax::CollectionBehavior
  end
end
