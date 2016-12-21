module Hyku
  class Group < ApplicationRecord
    self.table_name = 'hyku_groups'

    def number_of_users
      0
    end
  end
end
