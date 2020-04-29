require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = products(:product1)
    @variation = product_variations(:product_variation1)
  end

  test 'valid product' do
    assert @product.valid?
  end

  test 'product should have a name' do
    @product.name = ''
    assert_not @product.valid?
  end

  test 'product should have a price' do
    @product.price = nil
    assert_not @product.valid?
  end

  test 'product price should be a number greater or equal to zero' do
    @product.price = 'price'
    assert_not @product.valid?
    @product.price = -1
    assert_not @product.valid?
    @product.price = 0
    assert @product.valid?
  end

  test 'when destroy a product, its variations should be destroyed' do
      assert_difference 'ProductVariation.count', -1 do
        @product.destroy
      end
  end

  test 'when destroy a product, its product_categories should be destroyed' do
      assert_difference 'ProductCategory.count', -1 do
        @product.destroy
      end
  end
end
