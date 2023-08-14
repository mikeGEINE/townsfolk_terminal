# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ru/ do
    get 'booking/create'
    get 'booking/paid'
    get 'booking/input'
    get 'booking/checkin'

    get 'help', to: 'home#help'
  end

  get '/:locale' => 'home#index'
  root 'home#index'
end
