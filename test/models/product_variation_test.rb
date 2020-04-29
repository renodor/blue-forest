require 'test_helper'

class ProductVariationTest < ActiveSupport::TestCase
  def setup
    @product = products(:product1)
    @variation = product_variations(:product_variation1)
  end

  test "valid product variation" do
    assert @variation.valid?
  end

  test "product variation should be published by default" do
    assert @variation.published
  end

  test "product variation should have a quantity" do
    @variation.quantity = nil
    assert_not @variation.valid?
  end

  test "product variation should have a quantity greater or equal than 0" do
    @variation.quantity = 'q'
    assert_not @variation.valid?
    @variation.quantity = -1
    assert_not @variation.valid?
    @variation.quantity = 0
    assert @variation.valid?
  end
end
