require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @cart = carts(:cart1)
  end

  test 'should get show' do
    # get root_path
    # params = {}
    # session[:cart_id] = @cart.id
    # params[:id] = @cart.id

    # p "@cart.id: #{@cart.id} ----- "
    # p "session[:cart_id]: #{session[:cart_id]} ----- "
    # p "params[:id]: #{params[:id]} ----- "
    # get cart_path(@cart)
    # assert_response :success
  end
end
