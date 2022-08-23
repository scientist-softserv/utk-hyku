# frozen_string_literal: true

module UtkBaseTerms
  extend ActiveSupport::Concern

  included do
    # OVERRIDE allinson_flex(3eec46e): remove "source" from the "base_terms" method
    # because it's not in utk's metadata profile
    self.base_terms -= [:source]
  end
end
