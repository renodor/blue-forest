class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new show create shipping]
  before_action :new_order, only: %i[new create]
  before_action :find_user, only: %i[show new create]

  def show
    # prevent users from trying to access other users orders by changing the order id in the url
    redirect_to root_path if session[:order_id] != params[:id].to_i

    @order = Order.find(params[:id])

    # for now we will considere that users only have 1 address, so always take the first one
    # we could easily have users with many addresses in the future
    @address = @user.addresses.first
    set_breadcrumb_classes('hide-under-576', 'hide-under-576', nil, 'active')
  end

  def new
    # for now we will considere that users only have 1 address, so always take the first one
    # we could easily have users with many addresses in the future
    @address = @user.addresses.first
    set_breadcrumb_classes('hide-under-576', 'hide-under-576', 'active', 'pending')
  end

  def create
    user_signed_in? ? @order.user = @user : @order.fake_user = @user

    attach_cart_line_items_to_order
    attach_cart_details_to_order
    @order.save

    # link order to the session
    session[:order_id] = @order.id

    # destroy the current cart, because order has been confirmed
    # user can now create new cart with new products
    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil

    send_confirmations_emails
    redirect_to_correct_path
  end

  # aditional method and route just to redirect users to the correct new order path
  # if they start creating an order without being logged in and wants to log in afterword
  def login_before_new
    redirect_to new_user_order_path(current_user)
    return
  end

  private

  def find_user
    if user_signed_in?
      @user = current_user

      # security check that current user has an address
      redirect_to new_user_address_path(@user) if @user.addresses.empty?
    else
      @user = FakeUser.includes(:addresses).find(params[:fake_user_id])
    end
  end

  def new_order
    @order = Order.new
  end

  # define what part of order breadcrumb is active/pending or hidden en mobile
  # (depending on what step we are on the order funnel)
  # those are css classes
  def set_breadcrumb_classes(contact_class, shipping_class, review_class, confirm_class)
    @breadcrumb_contact_class = contact_class
    @breadcrumb_shipping_class = shipping_class
    @breadcrumb_review_class = review_class
    @breadcrumb_confirm_class = confirm_class
  end

  # append all line items of current cart to the order
  def attach_cart_line_items_to_order
    @current_cart.line_items.each do |line_item|
      @order.line_items << line_item

      # reduce stock quantity product variation by the quantity purchased of each line item
      new_quantity = line_item.product_variation.quantity - line_item.quantity
      line_item.product_variation.update(quantity: new_quantity)

      # remove the link between theses line items and the current cart
      # otherwises they will be destroyed when we destroy the cart later
      # (because of dependent destroy between cart and line items)
      line_item.cart_id = nil
    end
  end

  # append all order details of current cart to the order
  def attach_cart_details_to_order
    @order.sub_total = @current_cart.sub_total
    @order.total_items = @current_cart.total_items
    @order.shipping = @current_cart.shipping
    @order.itbms = @current_cart.itbms
    @order.total = @current_cart.total
  end

  def send_confirmations_emails
    # send confirmation email
    OrderMailer.confirmation(@order).deliver_now
    # send new order notice email (to admin)
    OrderMailer.new_order_notice(@order).deliver_now
  end

  # redirect to correct path regarding if its a user or a fake user
  def redirect_to_correct_path
    if user_signed_in?
      redirect_to user_order_path(@user, @order)
    else
      redirect_to fake_user_order_path(@user, @order)
    end
  end
end
