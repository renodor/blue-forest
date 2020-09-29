require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @product = products(:product1)
  end

  test 'should get products index' do
    get products_path
    assert_template 'layouts/homepage'
    assert_response :success
  end

  test 'should get product show' do
    get product_path(@product)
    assert_template 'layouts/pdp'
    assert_response :success
  end

  test 'product show should redirect to hp if product is not published' do
    @product.update(published: false)
    get product_path(@product)
    assert_redirected_to root_path
  end

  test 'product show should not redirect if product is not published but user is admin' do
    @product.update(published: false)

    user = users(:user1)
    user.update(admin: true)
    sign_in(user)

    get product_path(@product)
    assert_template 'layouts/pdp'
    assert_response :success
  end

  test 'products search' do
    get search_products_path(query: 'product1')
    assert_template 'products/search'
    assert_response :success
  end
end
