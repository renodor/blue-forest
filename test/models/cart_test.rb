require 'test_helper'

class CartTest < ActiveSupport::TestCase
  def setup
    @cart = carts(:cart1)
    @line_item1 = line_items(:line_item1)
    @line_item2 = line_items(:line_item2)
    @line_item3 = line_items(:line_item3)
  end

  test 'valid cart' do
    assert @cart.valid?
  end

  test 'when destroy a cart, its line items should be destroyed' do
    assert_difference 'LineItem.count', -3 do
      @cart.destroy
    end
  end

  test 'cart can access product variations and thus products from cart through line items' do
    assert_equal @cart.line_items.first.product_variation.product.name, 'product1'
  end

  test 'cart sub total instance method' do
    assert_equal @cart.sub_total, 121.5

    @cart.line_items = [@line_item1, @line_item2]
    assert_equal @cart.sub_total, 56.5

    @cart.line_items = [@line_item1]
    assert_equal @cart.sub_total, 10
  end

  test 'cart total items instance method' do
    assert_equal @cart.total_items, 5

    @cart.line_items = [@line_item1, @line_item2]
    assert_equal @cart.total_items, 4

    @cart.line_items = [@line_item1]
    assert_equal @cart.total_items, 1
  end

  test 'cart shipping instance method' do
    # assert_equal @cart.shipping, 0
    # @cart.line_items = [@line_item1, @line_item2]
    # assert_equal @cart.shipping, 5
    # @cart.line_items = [@line_item3]
    # assert_equal @cart.shipping, 0
  end

  test 'cart ITBMS instance method' do
    assert_equal @cart.itbms, 8.51

    @cart.line_items = [@line_item1, @line_item2]
    assert_in_delta @cart.itbms, 4.30, 0.01

    @cart.line_items = [@line_item1]
    assert_equal @cart.itbms, 1.05
  end

  test 'cart total instance method' do
    assert_equal @cart.total, 130.01

    @cart.line_items = [@line_item1, @line_item2]
    assert_in_delta @cart.total, 65.80, 0.01

    @cart.line_items = [@line_item1]
    assert_equal @cart.total, 16.05
  end
end
