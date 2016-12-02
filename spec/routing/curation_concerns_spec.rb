require 'rails_helper'

RSpec.describe Sufia::GenericWorksController do
  it "routes to manifest" do
    expect(get: '/concern/generic_works/1234/manifest')
      .to route_to(controller: 'sufia/generic_works', action: 'manifest', id: '1234')
  end
end
