# Customer organization account
class Account < ActiveRecord::Base
  # @param [String] piece the tenant piece of the canonical name
  # @return [String] full canonical name
  # @raise [ArgumentError] if piece contains a trailing dot
  # @see Settings.multitenancy.default_host
  def self.default_cname(piece)
    return unless piece
    raise ArgumentError, "param '#{piece}' must not contain trailing dots" if piece =~ /\.\Z/
    default_host = Settings.multitenancy.default_host || "%{tenant}.#{admin_host}"
    canonical_cname(format(default_host, tenant: piece.parameterize))
  end

  # Canonicalize the account cname or request host for comparison
  # @param [String] cname distinct part of host name
  # @return [String] canonicalized host name
  def self.canonical_cname(cname)
    # DNS host names are case-insensitive. Trim trailing dot(s).
    cname &&= cname.downcase.sub(/\.*\Z/, '')
    cname
  end

  def self.admin_host
    host = Settings.multitenancy.admin_host
    host ||= ENV['HOST']
    host ||= 'localhost'
    canonical_cname(host)
  end

  attr_readonly :tenant
  # name is unused after create, only used by sign_up/new forms
  validates :name,
            presence: true,
            unless: :cname_is_blank?

  validates :tenant, presence: true, uniqueness: true
  validates :cname, presence: true, uniqueness: true, exclusion: { in: [default_cname('')] }

  belongs_to :solr_endpoint, dependent: :delete
  belongs_to :fcrepo_endpoint, dependent: :delete
  belongs_to :redis_endpoint, dependent: :delete

  accepts_nested_attributes_for :solr_endpoint, :fcrepo_endpoint, :redis_endpoint, update_only: true

  before_validation do
    self.tenant ||= SecureRandom.uuid
    self.cname ||= self.class.default_cname(name)
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

  def solr_endpoint
    super || NilSolrEndpoint.new
  end

  def fcrepo_endpoint
    super || NilFcrepoEndpoint.new
  end

  def redis_endpoint
    super || NilRedisEndpoint.new
  end

  # Make all the account specific connections active
  def switch!
    solr_endpoint.switch!
    fcrepo_endpoint.switch!
    redis_endpoint.switch!
  end

  def switch
    switch!
    yield
  ensure
    reset!
  end

  def reset!
    SolrEndpoint.reset!
    FcrepoEndpoint.reset!
    RedisEndpoint.reset!
  end

  # Get list of all administrator emails associated with this account
  def admin_emails
    # Must ensure we are switched to proper tenant database
    Apartment::Tenant.switch(tenant) do
      # return (comma separated) list of email addresses of all users with admin role on this site
      User.with_role(:admin, Site.instance).map(&:email).join(', ')
    end
  end

  # Update administrator emails associated with this account
  def admin_emails=(value)
    emails = value.split(",").map(&:strip)
    # Must ensure we are switched to proper tenant database
    Apartment::Tenant.switch(tenant) do
      existing_admin_emails = User.with_role(:admin, Site.instance).map(&:email)
      new_admin_emails = emails - existing_admin_emails
      removed_admin_emails = existing_admin_emails - emails

      add_admins(new_admin_emails) if new_admin_emails
      remove_admins(removed_admin_emails) if removed_admin_emails
    end
  end

  private

    def default_cname(piece = name)
      self.class.default_cname(piece)
    end

    def cname_is_blank?
      cname.present? && cname != default_cname("")
    end

    def canonicalize_cname
      self.cname &&= self.class.canonical_cname(cname)
    end

    def add_admins(emails)
      # For users that already have accounts, add to role immediately
      existing_emails = User.where(email: emails).map do |u|
        u.add_role :admin, Site.instance
        u.email
      end
      # For new users, send invitation and add to role
      (emails - existing_emails).each do |email|
        u = User.invite!(email: email)
        u.add_role :admin, Site.instance
      end
    end

    def remove_admins(emails)
      User.where(email: emails).find_each do |u|
        u.remove_role :admin, Site.instance
      end
    end
end
