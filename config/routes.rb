# frozen_string_literal: true

Rails.application.routes.draw do
  get 'admin/view_accounts'
  get 'admin/view_rooms'
  post 'admin/update_account'
  get 'admin/update_room'
  get 'admin', to: 'admin#view_rooms'
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy'
  end
  get 'approve', to: 'home#approve'
  get 'base', to: 'home#base'
  scope '(:locale)', locale: /en|ru/ do
    get 'booking/create'
    get 'booking/paid'
    get 'booking/input'
    get 'booking/checkin'
    devise_for :users

    get 'help', to: 'home#help'
  end

  get '/:locale' => 'home#index'
  root 'home#index'
end
