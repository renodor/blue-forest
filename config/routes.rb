Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: [] do
    resources :orders, only: %i[index show new create]
    resources :addresses, only: %i[new create edit update]
  end

  resources :carts, only: %i[show destroy]
  resources :products do
    collection do
      get :search
    end
  end

  resources :product_variations

  resources :line_items, only: %i[create destroy] do
    member do
      post :change_quantity
      post :add_quantity
      post :reduce_quantity
    end
  end

  resources :fake_users, only: %i[new create edit update] do
    resources :orders, only: %i[show new create]
    resources :addresses, only: %i[new create edit update]
  end

  resources :categories, only: [:show]

  resources :product_favorites, only: %i[create destroy]

  # custom route to redirect user to the correct page
  # when the start an order and want to login after
  get 'login_before_new_order', to: 'orders#login_before_new'

  # route to the use profile page
  get 'dashboards', to: 'dashboards#dashboard'

  # route for product creation tool
  get 'product_creation', to: 'dashboards#product_creation_new'
  post 'product_creation', to: 'dashboards#product_creation_create'
  root to: 'products#index'

  # routes for info pages
  get 'privacy_policy', to: 'pages#privacy_policy'
  get 'terms_and_conditions', to: 'pages#terms_and_conditions'
  get 'returns_and_exchanges', to: 'pages#returns_and_exchanges'
  get 'shipping', to: 'pages#shipping'
  get 'faq', to: 'pages#faq'
  get 'about_us', to: 'pages#about_us'
  get 'covid_19', to: 'pages#covid_19'
  get 'wholesales', to: 'pages#wholesales'

  # route form doctor contact form
  post 'doctor_contact_form', to: 'doctors#doctor_contact_form'
end
