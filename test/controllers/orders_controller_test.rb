require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user1)
    @fake_user = fake_users(:fake_user1)
    @order = orders(:order1)
    @cart = carts(:cart1)
  end

  test 'should get new for users, if user is signed in' do
    sign_in(@user)
    assign(:address, addresses(:address2))
    get new_user_order_path(@user)
    p ">>>>>>>>>>>>>>>>>>>>>>>>>> #{assigns(:address).street}"
    assert_template 'orders/new'
    assert_response :success
  end

  # test 'should get new for fake users' do
  #   get new_fake_user_order_path(@fake_user)
  #   assert_template 'orders/new'
  #   assert_response :success
  # end

  # test 'create an order if user is signed in' do
  #   get user_order_path(@user, @order)
  #   assert_equal @order, assigns(:order)
  # end

  # test 'should get new for users, if user is signed in' do
  #   get root_path
  #   sign_in(@user)
  #   session[:order_id] = @order.id
  #   # p ">>>>>>>>>>>>>>>>>>>>>>> #{session[:order_id]}"
  #   # p ">>>>>>>>>>>>>>>>>>>>>>>> #{@order.id}"
  #   get user_order_path(@user, @order)
  #   # assert_template 'orders/show'
  #   assert_response :success
  # end
end
