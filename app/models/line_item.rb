class LineItem < ApplicationRecord
  belongs_to :product_variation
  belongs_to :cart
  belongs_to :order, optional: true

  validates :photo_key, presence: true

  before_validation :add_photo_key

  def total_price
    item_price = self.product_variation.discount_price || self.product_variation.price
    self.quantity * item_price
  end

  private

  # each time we create a new line_items, get the photo of this product and save its key to the line_item table
  # like that it is easier to get this photo every time we want to show it (cart, order summary etc...)
  # it prevent from doing to many table connections
  def add_photo_key
    product_photo = self.product_variation.product.product_photos.find do |product_photo|
      product_photo.color == self.product_variation.color
    end

    self.photo_key = product_photo.photos.first.key
  end
end
