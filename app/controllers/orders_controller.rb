class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :show, :create, :shipping]
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])

    if user_signed_in?
      @user = @order.user
      # for now we will considere that users only have 1 address, so always take the first one
      # we could easily have users with many addresses in the future
      @address = @user.addresses.first
    else
      @user = @order.fake_user
      # for now we will considere that users only have 1 address, so always take the first one
      # we could easily have users with many addresses in the future
      @address = @user.addresses.first
    end

    # prevent users from trying to access other users orders by changing the order id in the url
    redirect_to root_path if session[:order_id] != params[:id].to_i
  end

  def new
    @order = Order.new
    if user_signed_in?
      @user = User.includes(:addresses).find(current_user.id)

      # security check that current user has an address
      redirect_to new_user_address_path(@user) if @user.addresses.empty?

      # for now we will considere that users only have 1 address, so always take the first one
      # we could easily have users with many addresses in the future
      @address = @user.addresses.first
    else
      @user = FakeUser.includes(:addresses).find(params[:fake_user_id])
      # for now we will considere that users only have 1 address, so always take the first one
      # we could easily have users with many addresses in the future
      @address = @user.addresses.first
    end

  end

  def create
    if user_signed_in?
      @order = Order.new
      @user = current_user
      @order.user = @user
    else
      @order = Order.new
      @fake_user = FakeUser.find(params[:fake_user_id])
      @order.fake_user = @fake_user
    end

    # append all line items of current cart to the order
    @current_cart.line_items.each do |item|
      @order.line_items << item

      # reduce stock quantity product variation by the quantity purchased of each line item
      new_quantity = item.product_variation.quantity - item.quantity
      item.product_variation.update(quantity: new_quantity)

      # remove the link between theses line items and the current cart otherwises they will be destroyed when we destroy the cart later
      item.cart_id = nil
    end
    @order.save

    # link order to the session
    session[:order_id] = @order.id

    # destroy the current cart, because order has been confirmed and user can now create new cart with new products
    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil

    # send confirmation email
    OrderMailer.confirmation(@order).deliver_now

    # redirect to the correct path
    if @user
      redirect_to user_order_path(@user, @order)
    else
      redirect_to fake_user_order_path(@fake_user, @order)
    end
  end

  # aditional method and route to just to redirect users to the correct new order path if they start creating an order without being logged in and wants to log in afterword
  def login_before_new
    redirect_to new_user_order_path(current_user)
    return
  end
end
