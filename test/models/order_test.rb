require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = orders(:order1)
    @order2 = orders(:order2)
    @line_item1 = line_items(:line_item1)
    @line_item2 = line_items(:line_item2)
    @line_item3 = line_items(:line_item3)
  end

  test 'valid order with fake user' do
    assert @order.valid?
    assert_nil @order.user
  end

  test 'valid order with user' do
    assert @order2.valid?
    assert_nil @order2.fake_user
  end

  test 'order has many line items' do
    assert_equal @order.line_items.count, 3
  end

  test 'when destroy an order, its line_items should be destroyed' do
    assert_difference 'LineItem.count', -3 do
      @order.destroy
    end
  end

  test 'You can access product variations, and thus products, from order through line items' do
    assert_equal @order.product_variations.first.product.name, 'product1'
  end

  test 'order must have a sub total' do
    @order.sub_total = nil
    assert_not @order.valid?
  end

  test 'order must have a total items' do
    @order.total_items = nil
    assert_not @order.valid?
  end

  test 'order must have a shipping' do
    @order.shipping = nil
    assert_not @order.valid?
  end

  test 'order must have a itbms' do
    @order.itbms = nil
    assert_not @order.valid?
  end

  test 'order must have a total' do
    @order.total = nil
    assert_not @order.valid?
  end

  test 'order status must be confirmed by default' do
    assert_equal @order.status, 'confirmed'
  end

  test 'order status must be one of the following: confirmed, pick_pack, shipping, delivered' do
    @order.status = 'pick_pack'
    assert @order.valid?

    @order.status = 'shipping'
    assert @order.valid?

    @order.status = 'delivered'
    assert @order.valid?

    @order.status = 'other'
    assert_not @order.valid?
  end
end
