RSpec.describe Site, type: :model do
  describe ".instance" do
    it "is a singleton site" do
      expect(described_class.instance).to eq(described_class.instance)
    end
  end
end
