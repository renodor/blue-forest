require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  def setup
    @line_item = line_items(:line_item1)
    @line_item.cart = Cart.new
  end

  test 'valid line items' do
    assert @line_item.valid?
  end

  test 'line item quantity should be 1 by default' do
    line_item = LineItem.new
    assert_equal line_item.quantity, 1
  end

  test 'line item total price instance method' do
    item_price = @line_item.product_variation.discount_price || @line_item.product_variation.price
    total_price = item_price * @line_item.quantity
    assert_equal @line_item.total_price, total_price

    @line_item.quantity = 3
    assert_equal @line_item.total_price, item_price * 3

    @line_item.product_variation.discount_price = 9
    item_price = @line_item.product_variation.discount_price
    total_price = item_price * @line_item.quantity
    assert_equal @line_item.total_price, total_price
  end

  test 'line item add photo key method' do
    line_item = LineItem.new
    line_item.product_variation = product_variations(:product_variation1)

    product_photo = line_item.product_variation.product.product_photos.find do |photo|
      photo.color == product_variations(:product_variation1).color
    end
    line_item.save
    assert_equal line_item.photo_key, product_photo.photos.first.key
  end
end
