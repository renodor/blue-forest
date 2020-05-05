class CartsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :destroy]

  def show
    @cart = @current_cart
  end

  def destroy
    @cart = @current_cart
    @cart.destroy
    session[:cart_id] = nil
    redirect_to root_path
  end
end
