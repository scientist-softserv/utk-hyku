RSpec.configure do |config|
  # The before and after blocks must run instantaneously, because Capybara
  # might not actually be used in all examples where it's included.
  config.after do
    example = RSpec.current_example
    if example.metadata[:multitenant]
      allow(Settings.multitenancy).to receive(:enabled).and_call_original
      Rails.application.reload_routes!
    end
  end
  config.before do
    example = RSpec.current_example
    if example.metadata[:multitenant]
      allow(Settings.multitenancy).to receive(:enabled).and_return(true)
      Rails.application.reload_routes!
    end
  end
end
