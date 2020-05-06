class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :show, :create]
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
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

    @current_cart.line_items.each do |item|
      @order.line_items << item
      # item.cart_id = nil
    end
    @order.save
    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil
    redirect_to root_path
  end

  private

  def fake_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :address, :phone)
  end
end