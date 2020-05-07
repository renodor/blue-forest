class CartsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :destroy]

  def show
    @cart = @current_cart

    # prevent users from trying to access other users carts by changing the cart id in the url
    redirect_to cart_path(@cart) if @cart.id != params[:id].to_i
  end

  def destroy
    @cart = @current_cart
    @cart.destroy
    session[:cart_id] = nil
    redirect_to root_path
  end
end
