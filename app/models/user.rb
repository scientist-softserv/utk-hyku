# frozen_string_literal: true

class User < ApplicationRecord
  # Includes lib/rolify from the rolify gem
  rolify
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  attr_accessible :email, :password, :password_confirmation if Blacklight::Utils.needs_attr_accessible?
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[saml openid_connect cas]

  before_create :add_default_roles
  # set default scope to exclude guest users
  def self.default_scope
    where(guest: false)
  end

  scope :for_repository, -> {
    joins(:roles)
  }

  scope :registered, -> { for_repository.group(:id).where(guest: false) }

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth&.info&.email || [auth.uid, '@', Site.instance.account.email_domain].join if user.email.blank?
      user.password = Devise.friendly_token[0, 20]
      user.display_name = auth&.info&.name # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier.
  def to_s
    email
  end

  def is_admin
    has_role?(:admin) || has_role?(:admin, Site.instance)
  end

  def is_superadmin
    has_role? :superadmin
  end

  # Modified method from hydra-role-management Hydra::RoleManagement::UserRoles
  def is_admin
    has_role?(:admin, Site.instance)
  end
  # rubocop:disable Style/Alias
  alias_method :is_admin?, :is_admin
  alias_method :admin?, :is_admin

  # rubocop:enable Style/Alias

  # This comes from a checkbox in the proprietor interface
  # Rails checkboxes are often nil or "0" so we handle that
  # case directly
  def is_superadmin=(value)
    value = ActiveModel::Type::Boolean.new.cast(value)
    if value
      add_role :superadmin
    else
      remove_role :superadmin
    end
  end

  def site_roles
    roles.site
  end

  def site_roles=(roles)
    roles.reject!(&:blank?)

    existing_roles = site_roles.pluck(:name)
    new_roles = roles - existing_roles
    removed_roles = existing_roles - roles

    new_roles.each do |r|
      add_role r, Site.instance
    end

    removed_roles.each do |r|
      remove_role r, Site.instance
    end
  end

  def groups
    return ['admin'] if has_role?(:admin, Site.instance)
    []
  end

  # If this user is the first user on the tenant, they become its admin
  # unless we are in the global tenant
  def add_default_roles
    return if Account.global_tenant?

    add_role :admin, Site.instance unless self.class.joins(:roles).where("roles.name = ?", "admin").any?
    # Role for any given site
    add_role :registered, Site.instance
  end
end
