Rails.application.routes.draw do
  devise_for :users
  resources :carts, only: [:show, :destroy]
  resources :orders, only: [:index, :show, :new, :create]
  resources :products
  resources :line_items, only: [:create, :destroy] do
    member do
      post :add_quantity
      post :reduce_quantity
    end
  end
  root to: 'products#index'
end
