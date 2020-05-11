class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :fake_user, optional: true
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
    sub_total >= 65 ? 0 : 5
  end

  def itbms
    ((sub_total + shipping) * 0.07).round(2)
  end

  def total
    sub_total + itbms + shipping
  end
end
