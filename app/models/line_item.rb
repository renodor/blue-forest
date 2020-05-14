class LineItem < ApplicationRecord
  belongs_to :product_variation
  belongs_to :cart
  belongs_to :order, optional: true

  def total_price
    item_price = self.product_variation.discount_price || self.product_variation.price
    self.quantity * item_price
  end
end
