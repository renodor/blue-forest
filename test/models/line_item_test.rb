require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  def setup
    @line_item = line_items(:line_item1)
    @line_item.cart = Cart.new
  end

  test "valid product variation" do
    assert @line_item.valid?
  end

  test "line item quantity should be 1 by default" do
    line_item = LineItem.new
    assert_equal line_item.quantity, 1
  end

  test "line item total price instance method" do
    assert_equal @line_item.total_price, 10
    @line_item.quantity = 3
    assert_equal @line_item.total_price, 30
  end
end
