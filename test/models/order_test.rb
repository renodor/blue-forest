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

test 'order sub total instance method' do
    assert_equal @order.sub_total, 121.5

    @order.line_items = [@line_item1, @line_item2]
    assert_equal @order.sub_total, 56.5

    @order.line_items = [@line_item1]
    assert_equal @order.sub_total, 10
  end

  test 'order total items instance method' do
    assert_equal @order.total_items, 5

    @order.line_items = [@line_item1, @line_item2]
    assert_equal @order.total_items, 4

    @order.line_items = [@line_item1]
    assert_equal @order.total_items, 1
  end

  test 'order shipping instance method' do
    assert_equal @order.shipping, 0
    @order.line_items = [@line_item1, @line_item2]
    assert_equal @order.shipping, 5
    @order.line_items = [@line_item3]
    assert_equal @order.shipping, 0
  end

  test 'order ITBMS instance method' do
    assert_equal @order.itbms, 8.51

    @order.line_items = [@line_item1, @line_item2]
    assert_in_delta @order.itbms, 4.30, 0.01

    @order.line_items = [@line_item1]
    assert_equal @order.itbms, 1.05
  end

  test 'order total instance method' do
    assert_equal @order.total, 130.01

    @order.line_items = [@line_item1, @line_item2]
    assert_in_delta @order.total, 65.80, 0.01

    @order.line_items = [@line_item1]
    assert_equal @order.total, 16.05
  end
end
