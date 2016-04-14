class Ability
  include Hydra::Ability

  include CurationConcerns::Ability
  include Sufia::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns, :superadmin_permissions]

  # Define any customized permissions here.
  def custom_permissions
    can [:create], Account
  end

  def admin_permissions
    super

    can [:manage], [Site, Role]

    restrict_site_admin_permissions unless current_user.has_role? :superadmin
  end

  def superadmin_permissions
    can :manage, :all if current_user.has_role? :superadmin
  end

  def restrict_site_admin_permissions
    # override curation_concerns admin roles to disable admin privileges on global models
    cannot [:manage, :create, :discover, :show, :read, :edit, :update, :destroy], global_models

    can [:read, :update], Account do |account|
      account == Site.account
    end
  end

  private

    def global_models
      [Account]
    end

    # Override admin? helper to use rolify roles
    def admin?
      current_user.has_role?(:admin, Site.instance)
    end
end
