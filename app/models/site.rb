class Site < ActiveRecord::Base
  validates :application_name, presence: true, allow_nil: true

  belongs_to :account
  accepts_nested_attributes_for :account, update_only: true

  def self.instance
    first || create
  end
end
