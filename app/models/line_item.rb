class LineItem < ApplicationRecord
  belongs_to :product_variation
  belongs_to :cart
  belongs_to :order, optional: true
end
