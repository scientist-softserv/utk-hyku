# frozen_string_literal: true

# OVERRIDE Hyrax 3.4.1 to fix #5788
module AdminSetDecorator
  def assign_id
    super || SecureRandom.uuid
  end
end

AdminSet.prepend(AdminSetDecorator)
