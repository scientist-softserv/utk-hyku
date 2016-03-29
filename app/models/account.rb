class Account < ActiveRecord::Base
  attr_readonly :tenant
  validates :tenant, presence: true, uniqueness: true
  validates :cname, presence: true, uniqueness: true
end
