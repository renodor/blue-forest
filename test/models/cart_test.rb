require 'test_helper'

class CartTest < ActiveSupport::TestCase
  def setup
    @cart = carts(:cart1)
    @line_item1 = line_items(:line_item1)
    @line_item2 = line_items(:line_item2)
    @line_item3 = line_items(:line_item3)

    @sub_total1 = @line_item1.total_price + @line_item2.total_price + @line_item3.total_price
    @sub_total2 = @line_item1.total_price + @line_item2.total_price
    @sub_total3 = @line_item1.total_price
  end

  test 'valid cart' do
    assert @cart.valid?
  end

  test 'when destroy a cart, its line items should be destroyed' do
    assert_difference 'LineItem.count', -3 do
      @cart.destroy
    end
  end

  test 'by default cart line items are orered by creation date' do
    @line_item1.update(created_at: Time.now)
    assert_equal @cart.line_items, @cart.line_items.order(created_at: :asc)
  end

  test 'cart can access product variations and thus products from cart through line items' do
    assert_equal @cart.line_items.first.product_variation.product.name, 'product1'
  end

  test 'cart model must have a SHIPPING_PRICE constant' do
    assert_not_nil Cart::SHIPPING_PRICE
  end

  test 'cart model must have a FREE_SHIPPING_THRESHOLD constant' do
    assert_not_nil Cart::FREE_SHIPPING_THRESHOLD
  end

  test 'cart model must have a TAX value constant' do
    assert_not_nil Cart::TAX
  end

  test 'cart sub total instance method' do
    assert_equal @cart.sub_total, @sub_total1

    @cart.line_items = [@line_item1, @line_item2]
    assert_equal @cart.sub_total, @sub_total2

    @cart.line_items = [@line_item1]
    assert_equal @cart.sub_total, @sub_total3
  end

  test 'cart total items instance method' do
    total_items1 = @line_item1.quantity + @line_item2.quantity + @line_item3.quantity
    assert_equal @cart.total_items, total_items1

    @cart.line_items = [@line_item1, @line_item2]
    total_items2 = @line_item1.quantity + @line_item2.quantity
    assert_equal @cart.total_items, total_items2

    @cart.line_items = [@line_item1]
    total_items3 = @line_item1.quantity
    assert_equal @cart.total_items, total_items3
  end

  test 'cart shipping instance method' do
    if @cart.sub_total >= Cart::FREE_SHIPPING_THRESHOLD
      assert_equal @cart.shipping, 0
    else
      assert_equal @cart.shipping, Cart::SHIPPING_PRICE
    end

    @cart.line_items = [@line_item1, @line_item2]
    if @cart.sub_total >= Cart::FREE_SHIPPING_THRESHOLD
      assert_equal @cart.shipping, 0
    else
      assert_equal @cart.shipping, Cart::SHIPPING_PRICE
    end

    @cart.line_items = [@line_item3]
    if @cart.sub_total >= Cart::FREE_SHIPPING_THRESHOLD
      assert_equal @cart.shipping, 0
    else
      assert_equal @cart.shipping, Cart::SHIPPING_PRICE
    end
  end

  test 'cart ITBMS instance method' do
    assert_equal @cart.itbms, ((@cart.sub_total + @cart.shipping) * Cart::TAX).round(2)

    @cart.line_items = [@line_item1, @line_item2]
    assert_equal @cart.itbms, ((@cart.sub_total + @cart.shipping) * Cart::TAX).round(2)

    @cart.line_items = [@line_item1]
    assert_equal @cart.itbms, ((@cart.sub_total + @cart.shipping) * Cart::TAX).round(2)
  end

  test 'cart total instance method' do
    assert_equal @cart.total, @cart.sub_total + @cart.shipping + @cart.itbms

    @cart.line_items = [@line_item1, @line_item2]
    assert_equal @cart.total, @cart.sub_total + @cart.shipping + @cart.itbms

    @cart.line_items = [@line_item1]
    assert_equal @cart.total, @cart.sub_total + @cart.shipping + @cart.itbms
  end
end
