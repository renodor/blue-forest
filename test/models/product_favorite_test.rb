require 'test_helper'

class ProductFavoriteTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @product = products(:product1)

    @product_favorite1 = ProductFavorite.new
    @product_favorite1.user = @user
    @product_favorite1.product = @product
    @product_favorite1.save

    @product_favorite2 = ProductFavorite.new
    @product_favorite2.user = @user
    @product_favorite2.product = @product
  end

  test 'valid product favorite' do
    assert @product_favorite1.valid?
  end

  test "a user can't add the same product several times in his favorites" do
    @product_favorite2.product = @product
    assert_not @product_favorite2.valid?
  end
end
