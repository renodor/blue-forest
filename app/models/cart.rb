class Cart < ApplicationRecord
  SHIPPING_PRICE = 3.5
  FREE_SHIPPING_THRESHOLD = 65
  TAX = 0.07
  has_many :line_items, dependent: :destroy
  has_many :product_variations, through: :line_items

  def sub_total
    sum = 0
    line_items.each do |line_item|
      sum += line_item.total_price
    end
    sum
  end

  def total_items
    qty = 0
    line_items.each do |item|
      qty += item.quantity
    end
    qty
  end

  def shipping
    sub_total >= FREE_SHIPPING_THRESHOLD ? 0 : SHIPPING_PRICE
  end

  def itbms
    ((sub_total + shipping) * TAX).round(2)
  end

  def total
    sub_total + itbms + shipping
  end
end
