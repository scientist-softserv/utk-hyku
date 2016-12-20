module Hyku
  class Group
    attr_accessor :name, :description

    def initialize(name:, description:)
      @name = name
      @description = description
    end

    def number_of_members
      0
    end
  end
end
