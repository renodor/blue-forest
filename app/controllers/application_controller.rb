class ApplicationController < ActionController::Base
  # permiting personal parameters to devise controller
  before_action :configure_permitted_parameters, if: :devise_controller?
  # store current url before redirect to login page in order to retrieve it after login
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!

  # automaticaly create a cart when a new session is created
  before_action :current_cart



  private


  def configure_permitted_parameters
    # Permit the `subscribe_newsletter` parameter along with the other
    # sign up parameters.
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])
  end


  # The callback which stores the current location must be added before you authenticate the user
  # as `authenticate_user!` will halt the filter chain and redirect
  # before the location can be stored.

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  # We want the Cart to be accessible throughout the entire app so we store it in the application_controller. We want to create a new Cart model each time a user visits the site and store that cart_id in a session[:cart_id]
  def current_cart
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
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
