Rails.application.routes.draw do
  devise_for :users
  resources :carts, only: [:show, :destroy]
  resources :orders, only: [:index, :show, :new, :create]
  resources :products
  resources :line_items, only: [:create]
  root to: 'products#index'
end
