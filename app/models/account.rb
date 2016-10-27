# Customer organization account
class Account < ActiveRecord::Base
  attr_readonly :tenant
  validates :name, presence: true
  validates :tenant, presence: true, uniqueness: true
  validates :cname, presence: true, uniqueness: true

  belongs_to :solr_endpoint, dependent: :delete
  belongs_to :fcrepo_endpoint, dependent: :delete
  belongs_to :redis_endpoint, dependent: :delete

  accepts_nested_attributes_for :solr_endpoint, :fcrepo_endpoint, :redis_endpoint, update_only: true

  before_validation do
    self.tenant ||= SecureRandom.uuid
    self.cname ||= default_cname
  end

  before_save :canonicalize_cname

  # @return [Account]
  def self.from_request(request)
    find_by(cname: canonical_cname(request.host))
  end

  # @return [Account] a placeholder account using the default connections configured by the application
  def self.single_tenant_default
    Account.new do |a|
      a.build_solr_endpoint
      a.build_fcrepo_endpoint
      a.build_redis_endpoint
    end
  end

  # Canonicalize the account cname or request host for comparison
  #
  # @param [String] host name
  # @return [String] canonicalized host name
  def self.canonical_cname(cname)
    # DNS host names are case insensitive
    cname &&= cname.downcase

    # convert complete domain names to relative names
    cname &&= cname.sub(/\.\Z/, '')

    cname
  end

  def switch!
    solr_endpoint.switch! if solr_endpoint
    fcrepo_endpoint.switch! if fcrepo_endpoint
    redis_endpoint.switch! if redis_endpoint
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
    redis_endpoint.reset! if redis_endpoint
  end

  private

    def default_cname
      return unless name

      default_host = Settings.multitenancy.default_host
      default_host % { tenant: name.parameterize }
    end

    def canonicalize_cname
      self.cname &&= self.class.canonical_cname(cname)
    end
end
