class LineItem < ApplicationRecord
  belongs_to :product_variation
  belongs_to :cart, optional: true
  belongs_to :order, optional: true

  before_validation :add_photo_key

  def total_price
    item_price = product_variation.discount_price || product_variation.price
    quantity * item_price
  end

  private

  # each time we create a new line_items, find the product photo and save its key
  # So that it is easier to get this photo every time we need it (cart, order summary etc...)
  # it prevent from doing to many table connections
  def add_photo_key
    product_photo = product_variation.product.product_photos.find do |photo|
      photo.color == product_variation.color
    end

    self.photo_key = product_photo.photos.first.key if product_photo
  end
end
