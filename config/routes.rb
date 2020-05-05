Rails.application.routes.draw do
  devise_for :users
  resources :cart, only: [:show, :destroy]
  root to: 'products#index'
end
