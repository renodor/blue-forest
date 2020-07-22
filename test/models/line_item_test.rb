require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  def setup
    @line_item = line_items(:line_item1)
    @line_item2 = line_items(:line_item2)
    @variation = product_variations(:product_variation1)
    @line_item.cart = Cart.new
  end

  test 'valid line item' do
    # assert @line_item.valid?
    # @line_item.product_variation.product.product_photos
  end

  test 'line item quantity should be 1 by default' do
    line_item = LineItem.new
    assert_equal line_item.quantity, 1
  end

  test 'line item total price instance method' do
    assert_equal @line_item.total_price, 10
    @line_item.quantity = 3
    assert_equal @line_item.total_price, 30
    assert_equal @line_item2.total_price, 46.5
  end
end
