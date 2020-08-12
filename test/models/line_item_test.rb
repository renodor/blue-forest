require 'test_helper'
require 'open-uri'

class LineItemTest < ActiveSupport::TestCase
  def setup
    @line_item = line_items(:line_item1)
    @line_item2 = line_items(:line_item2)
    @variation = product_variations(:product_variation1)
    @line_item.cart = Cart.new

    @line_item.product_variation.product.product_photos.first.photos.attach(
      [
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846867/744-500x500_q9y6wr.jpg'),
          filename: '1.png', content_type: 'image/jpg' },
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/861-500x500_s0fflw.jpg'),
          filename: '2.png', content_type: 'image/jpg' }
      ]
    )
  end

  test 'valid line item' do
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
    product_photo = @line_item.product_variation.product.product_photos.find do |photo|
      photo.color == @variation.color
    end
    @line_item.save
    assert_equal @line_item.photo_key, product_photo.photos.first.key
  end
end
