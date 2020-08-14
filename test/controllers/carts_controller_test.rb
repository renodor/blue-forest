require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @cart = carts(:cart1)
  end

  test 'should get show' do
    # it seems that each test line create a new session...
    # so the only way to have the cart id equal to session[:cart_id] is to anticipate it adding 1
    get root_path
    @cart.id = session[:cart_id] + 1
    get cart_path(@cart)
    assert_template 'carts/show'
    assert_response :success
  end

  test 'user should be redirected to correct cart if cart id is not equal to session[:cart_id]' do
    get cart_path(@cart)
    assert_redirected_to "http://www.example.com/carts/#{session[:cart_id]}"
  end
end
