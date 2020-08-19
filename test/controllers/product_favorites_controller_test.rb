require 'test_helper'
require 'json'

class ProductFavoritesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user1)
    @product = products(:product3)
  end

  test 'create product favorite' do
    sign_in(@user)
    assert_difference 'ProductFavorite.count', 1 do
      post product_favorites_path(product_id: @product.id), xhr: true
    end
    response = { product_favorite_id: ProductFavorite.last.id }.to_json
    assert_equal 'application/json; charset=utf-8', @response.content_type
    assert_equal response, @response.body
  end

  test 'remove product from favorites' do
    sign_in(@user)
    assert_difference 'ProductFavorite.count', -1 do
      delete product_favorite_path(product_favorites(:product_favorite1).id), xhr: true
    end
  end

  test 'create product favorite should redirect if user not signed in' do
    assert_no_difference 'ProductFavorite.count' do
      post product_favorites_path(product_id: @product.id), xhr: true
    end
    assert_response :unauthorized
    assert_equal 'Tienes que iniciar sesión o registrarte para poder continuar.', @response.body
  end
end
