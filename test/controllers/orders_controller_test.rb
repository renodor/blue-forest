require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user1)
    @fake_user = fake_users(:fake_user1)
    @order = orders(:order1)
  end

  test 'should get new for users, if user is signed in' do
    sign_in(@user)
    get new_user_order_path(@user)
    assert_template 'orders/new'
    assert_response :success
  end

  test 'should get new for fake users' do
    get new_fake_user_order_path(@fake_user)
    assert_template 'orders/new'
    assert_response :success
  end

  test 'create an order if user is signed in' do
    sign_in(@user)
    assert_difference 'Order.count', 1 do
      post user_orders_path(@user)
    end
    # # new address should belong to user
    # assert_equal Address.last.user, @user
    # # fake user should be nil
    # assert_nil Address.last.fake_user
    # # redirect to new order path for fake users
    # assert_redirected_to new_user_order_path(@user)
  end

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
