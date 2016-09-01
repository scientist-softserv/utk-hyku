class AccountsController < ApplicationController
  skip_before_action :require_active_account!
  layout 'admin'

  load_and_authorize_resource

  # GET /accounts
  # GET /accounts.json
  def index
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
  end

  # GET /accounts/1/edit
  def edit
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

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    CleanupAccountJob.perform_now(@account)

    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def first_user_registration_url
      new_user_registration_url(host: @account.cname)
    end

    def create_params
      params.require(:account).permit(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :cname,
                                      solr_endpoint_attributes: [:id, :url],
                                      fcrepo_endpoint_attributes: [:id, :url, :base_path])
    end
end
