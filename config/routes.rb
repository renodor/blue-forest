Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :user do
    resources :orders, only: [:index, :show, :new, :create]
    resources :addresses, only: [:new, :create]
  end
  resources :carts, only: [:show, :destroy]
  resources :products
  resources :line_items, only: [:create, :destroy] do
    member do
      post :add_quantity
      post :reduce_quantity
    end
  end
  resources :fake_users, only: [:new, :create] do
    resources :orders, only: [:index, :show, :new, :create]
    resources :addresses, only: [:new, :create]
  end
  get 'login_before_new_order', to: 'orders#login_before_new'
  root to: 'products#index'
end
