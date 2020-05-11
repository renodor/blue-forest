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

  test "product should be published by default" do
    assert @product.published
  end

  test 'when destroy a product, its variations should be destroyed' do
    assert_difference 'ProductVariation.count', -3 do
      @product.destroy
    end
  end

  test 'when destroy a product, its product_categories should be destroyed' do
    assert_difference 'ProductCategory.count', -1 do
      @product.destroy
    end
  end
end
