class AccountSignUpController < ApplicationController
  skip_before_action :require_active_account!
  load_and_authorize_resource instance_name: :account, class: 'Account'

  # GET /accounts/new
  def new
    add_breadcrumb t(:'hyrax.controls.home'), root_path
    add_breadcrumb 'New account', new_account_path
  end

  # POST /accounts
  # POST /accounts.json
  def create
    respond_to do |format|
      if CreateAccount.new(@account).save
        format.html { redirect_to first_user_registration_url, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account.cname }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def first_user_registration_url
      new_user_registration_url(host: @account.cname)
    end

    def create_params
      params.require(:account).permit(:name)
    end
end
