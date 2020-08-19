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

  end
end
