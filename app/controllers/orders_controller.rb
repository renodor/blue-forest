class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :show, :create]
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])

    # prevent users from trying to access other users orders by changing the order id in the url
    redirect_to root_path if session[:order_id] != params[:id].to_i
  end

  def new
    @order = Order.new
  end

  def create
    if user_signed_in?
      @order = Order.new(user_id: current_user.id)
    else
      # if user wants to order without account, create a 'fake' user without validation
      fake_user = FakeUser.create(fake_user_params)
      @order = Order.new(fake_user_id: fake_user.id)
    end


    # append all line items of current cart to the order
    @current_cart.line_items.each do |item|
      @order.line_items << item
      # remove the link between theses line items and the current cart otherwises they will be destroyed when we destroy the cart later
      item.cart_id = nil
    end
    @order.save

    # link order to the session
    session[:order_id] = @order.id

    # destroy the current cart, because order has been confirmed and user can now create new cart with new products
    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil
    redirect_to order_path(@order)
  end

  private

  def fake_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :address, :phone)
  end
end
