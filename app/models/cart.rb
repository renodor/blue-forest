class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :product_variations, through: :line_items

  def sub_total
    sum = 0
    self.line_items.each do |line_item|
      sum += line_item.total_price
    end
    sum
  end

  def total_items
    qty = 0
    self.line_items.each do |item|
      qty += item.quantity
    end
    qty
  end

  def shipping
    sub_total > 65 ? 0 : 5
  end

  def itbms
    (sub_total * 0.07).round(2)
  end

  def total
    sub_total + shipping + itbms
  end
end
