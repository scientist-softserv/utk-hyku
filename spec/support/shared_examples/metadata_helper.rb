# frozen_string_literal: true

RSpec.shared_examples "SharedWorkBehavior" do
  it "includes SharedWorkBehavior" do
    # Comes from including SharedWorkBehavior
    # Test a small subset of the properties available.
    expect(subject).to respond_to(:bulkrax_identifier)
  end
end
