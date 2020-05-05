class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :current_cart


  # We want the Cart to be accessible throughout the entire app so we store it in the application_controller. We want to create a new Cart model each time a user visits the site and store that cart_id in a session[:cart_id]

  private

  def current_cart
    if session[:cart_id]
      cart = Cart.find(session[:cart_id])
      if cart.present?
        @current_cart = cart
      else
        session[:cart_id] = nil
      end
    end

    if session[:cart_id].nil?
      @current_cart = Cart.create
      session[:cart_id] = @current_cart.id
    end
  end
end
