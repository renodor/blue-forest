require 'test_helper'

class ProductFavoriteTest < ActiveSupport::TestCase
  def setup
    @product_favorite1 = product_favorites(:product_favorite1)
    @product_favorite2 = product_favorites(:product_favorite2)
  end

  test 'valid product favorite' do
    assert @product_favorite1.valid?
  end

  test "a user can't add the same product several times in his favorites" do
    @product_favorite2.product = @product
    assert_not @product_favorite2.valid?
  end
end
