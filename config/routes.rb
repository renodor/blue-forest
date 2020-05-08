Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :carts, only: [:show, :destroy]
  resources :orders, only: [:index, :show, :new, :create] do
    collection do
      get :shipping
    end
  end
  resources :products
  resources :line_items, only: [:create, :destroy] do
    member do
      post :add_quantity
      post :reduce_quantity
    end
  end
  resources :addresses, only: [:new, :create]
  root to: 'products#index'
end
