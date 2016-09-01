class AccountsController < ApplicationController
  skip_before_action :require_active_account!

  # The new layout is used by admins and on the signup page, so don't
  # use the admin layout.
  # TODO: create a separate signup controller?
  layout :decide_layout

  load_and_authorize_resource

  # GET /accounts
  # GET /accounts.json
  def index
    authorize! :manage, Account
    add_breadcrumb t(:'sufia.controls.home'), root_path
    add_breadcrumb t(:'sufia.toolbar.admin.menu'), sufia.admin_path
    add_breadcrumb t(:'sufia.admin.sidebar.accounts'), accounts_path
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    add_breadcrumb t(:'sufia.controls.home'), root_path
    add_breadcrumb t(:'sufia.toolbar.admin.menu'), sufia.admin_path
    add_breadcrumb t(:'sufia.admin.sidebar.accounts'), accounts_path
    add_breadcrumb 'New account', new_account_path
  end

  # GET /accounts/1/edit
  def edit
    add_breadcrumb t(:'sufia.controls.home'), root_path
    add_breadcrumb t(:'sufia.toolbar.admin.menu'), sufia.admin_path
    add_breadcrumb t(:'sufia.admin.sidebar.accounts'), accounts_path
    add_breadcrumb @account.tenant, edit_account_path(@account)
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

    def decide_layout
      if can? :read, :admin_dashboard
        'admin'
      else
        'sufia-one-column'
      end
    end

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
