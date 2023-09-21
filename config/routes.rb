# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    root to: '/admin#view_rooms'
    get 'view_accounts'
    get 'view_rooms'
    post 'update_account'
    post 'update_room'
    get 'sync_rooms', to: '/admin#sync_rooms'
  end

  scope '(:locale)', locale: /en|ru/ do
    get 'booking/create'
    get 'booking/paid'
    get 'booking/input'
    get 'booking/checkin'

    get 'help', to: 'home#help'
  end

  devise_for :users
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy'
  end
  get 'approve', to: 'home#approve'
  get 'about', to: 'home#about'

  get '/:locale' => 'home#index'
  root 'home#index'
end
