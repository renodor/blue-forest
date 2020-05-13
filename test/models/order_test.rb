require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = orders(:order1)
    @order2 = orders(:order2)
    @line_item1 = line_items(:line_item1)
    @line_item2 = line_items(:line_item2)
    @line_item3 = line_items(:line_item3)
  end

  test "valid order with fake user" do
    assert @order.valid?
  end

  test "valid order with user" do
    assert @order2.valid?
  end

  test 'when destroy an order, its line_items should be destroyed' do
    assert_difference 'LineItem.count', -3 do
      @order.destroy
    end
  end

  test 'You can access product variations, and thus products, from order through line items' do
    assert_equal @order.product_variations.first.product.name, 'product1'
  end
end
