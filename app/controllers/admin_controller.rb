class AdminController < ApplicationController
  layout 'simple'
  before_action :admin_auth

  def view_accounts
    @users = User.all
  end

  def view_rooms
  end

  # TODO: Rewrite in a safer way
  def update_account
    acc = User.find(account_params[:account_id])
    acc.role = User.roles[account_params[:role]]
    acc.save
    redirect_to admin_view_accounts_path
  end

  def update_room
  end

  private

  def admin_auth
    raise ActionController::RoutingError, 'Not Found' unless current_user.admin?
  end

  def account_params
    params.permit(:account_id, :role)
  end
end
