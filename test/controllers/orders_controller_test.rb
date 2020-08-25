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
    get new_user_order_path(@user)
    assert_template 'orders/new'
    assert_response :success
  end

  test 'should redirect user if trying to access new orders without address' do
    @user.addresses.first.delete
    sign_in(@user)
    get new_user_order_path(@user)
    assert_redirected_to new_user_address_path(@user)
  end

  test 'should get new for fake users' do
    get new_fake_user_order_path(@fake_user)
    assert_template 'orders/new'
    assert_response :success
  end

  test 'login before new route should redirect logged out users to login page' do
    get login_before_new_order_path
    assert_redirected_to new_user_session_path
  end

  test 'login before new route should redirect logged in users to new user order page' do
    sign_in(@user)
    get login_before_new_order_path
    assert_redirected_to new_user_order_path(@user)
  end
end
