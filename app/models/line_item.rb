class LineItem < ApplicationRecord
  belongs_to :product_variation
  belongs_to :cart
  belongs_to :order, optional: true

  def total_price
    self.quantity * self.product_variation.price
  end
end
