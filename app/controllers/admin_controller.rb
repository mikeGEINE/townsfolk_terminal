class AdminController < ApplicationController
  layout 'simple'
  before_action :admin_auth

  def view_accounts
    @users = User.all
  end

  def view_rooms
    @rooms = Room.order(id: :asc).all
  end

  # TODO: Rewrite in a safer way
  def update_account
    User.find(account_params[:id]).update!(account_params)
    redirect_to admin_view_accounts_path
  end

  def update_room
    Room.find(room_params[:id]).update!(room_params)
    redirect_to admin_view_rooms_path
  end

  def sync_rooms
    UpdateRooms.call().either(
      ->(res) { redirect_to admin_view_rooms_path, notice: 'Synced with Bnovo successfully'},
      ->(err_code) { redirect_to admin_view_rooms_path, error: t(err_code) }
    )
  end

  private

  def admin_auth
    raise ActionController::RoutingError, 'Not Found' unless current_user.admin?
  end

  def account_params
    params.require(:account).permit(:id, :role)
  end

  def room_params
    params.require(:room).permit(:id, :status, :code)
  end
end
