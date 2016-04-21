# Customer organization account
class Account < ActiveRecord::Base
  attr_readonly :tenant
  validates :tenant, presence: true, uniqueness: true
  validates :cname, presence: true, uniqueness: true

  belongs_to :solr_endpoint
  belongs_to :fcrepo_endpoint

  accepts_nested_attributes_for :solr_endpoint, :fcrepo_endpoint, update_only: true

  # @return [Account]
  def self.from_request(request)
    find_by(cname: request.host)
  end

  def switch!
    solr_endpoint.switch! if solr_endpoint
    fcrepo_endpoint.switch! if fcrepo_endpoint
  end
end
