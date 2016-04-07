class Site < ActiveRecord::Base
  validates :application_name, presence: true, allow_nil: true

  def self.instance
    first || create
  end
end
