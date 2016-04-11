# Customer organization account
class Account < ActiveRecord::Base
  attr_readonly :tenant
  validates :tenant, presence: true, uniqueness: true
  validates :cname, presence: true, uniqueness: true

  # @return [Account]
  def self.from_request(request)
    find_by(cname: request.host)
  end

  def save_and_create_tenant
    save.tap do |result|
      break unless result

      Apartment::Tenant.create(tenant) do
        Site.update(account: self)
        yield if block_given?
      end
    end
  end
end
