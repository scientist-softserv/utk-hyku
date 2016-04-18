class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds CurationConcerns behaviors to the application controller.
  include CurationConcerns::ApplicationControllerBehavior
  # Adds Sufia behaviors into the application controller
  include Sufia::Controller

  include CurationConcerns::ThemedLayoutController
  layout 'sufia-one-column'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :peek_enabled?

  before_action :require_active_account!, if: :multitenant?
  before_action :set_account_specific_connections!

  rescue_from Apartment::TenantNotFound do
    redirect_to accounts_path
  end

  private

    def peek_enabled?
      can? :peek, Lerna::Application
    end

    def require_active_account!
      raise Apartment::TenantNotFound, "No tenant for #{request.host}" unless current_account
    end

    def set_account_specific_connections!
      current_account.switch! if current_account
    end

    def multitenant?
      Settings.multitenant
    end

    def current_account
      @current_account ||= Account.from_request(request)
    end

    # Add context information to the lograge entries
    def append_info_to_payload(payload)
      super
      payload[:request_id] = request.uuid
      payload[:user_id] = current_user.id if current_user
      payload[:account_id] = current_account.cname if current_account
    end
end
