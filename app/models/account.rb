# Customer organization account
class Account < ActiveRecord::Base
  attr_readonly :tenant
  validates :name, presence: true
  validates :tenant, presence: true, uniqueness: true
  validates :cname, presence: true, uniqueness: true

  belongs_to :solr_endpoint, dependent: :delete
  belongs_to :fcrepo_endpoint, dependent: :delete

  accepts_nested_attributes_for :solr_endpoint, :fcrepo_endpoint, update_only: true

  before_validation do
    self.tenant ||= SecureRandom.uuid
    self.cname ||= Settings.multitenancy.default_host % { tenant: name.parameterize } if name
  end

  # @return [Account]
  def self.from_request(request)
    find_by(cname: request.host)
  end

  def switch!
    solr_endpoint.switch! if solr_endpoint
    fcrepo_endpoint.switch! if fcrepo_endpoint
  end

  def switch
    switch!
    yield
  ensure
    reset!
  end

  def reset!
    solr_endpoint.reset! if solr_endpoint
    fcrepo_endpoint.reset! if fcrepo_endpoint
  end
end
