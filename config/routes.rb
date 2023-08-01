# frozen_string_literal: true

Rails.application.routes.draw do
  get 'booking/create'
  get 'booking/paid'
  get 'booking/input'
  get 'booking/checkin'
  root 'home#index'

  get 'help', to: 'home#help'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
