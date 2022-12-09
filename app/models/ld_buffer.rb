# frozen_string_literal: true

# This method corresponds to an entry in our linked data buffer
# When we retrieve a label from an externally controlled vocabulary,
# The url and label are buffered here so they need not be looked up again.
# Old buffer entries are automatically deleted.
class LdBuffer < ApplicationRecord
end
