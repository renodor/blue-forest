class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :product_variation, through: :line_items
end
