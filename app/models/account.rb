# Customer organization account
class Account < ActiveRecord::Base
  attr_readonly :tenant
  validates :tenant, presence: true, uniqueness: true
  validates :cname, presence: true, uniqueness: true

  belongs_to :solr_endpoint

  before_create :create_default_solr_endpoint

  accepts_nested_attributes_for :solr_endpoint, update_only: true

  # @return [Account]
  def self.from_request(request)
    find_by(cname: request.host)
  end

  def switch!
    solr_endpoint.switch! if solr_endpoint
  end

  def save_and_create_tenant(&block)
    save.tap do |result|
      break unless result

      create_tenant(&block)
    end
  end

  def create_tenant
    Apartment::Tenant.create(tenant) do
      Site.update(account: self)
      yield if block_given?
    end
  end

  def create_default_solr_endpoint
    self.solr_endpoint ||= create_solr_endpoint(SolrEndpoint.default_options)
  end
end
