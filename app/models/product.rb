class Product < ApplicationRecord
  has_many :product_variations, dependent: :destroy
  has_many :categories, through: :product_categories, dependent: :destroy

  validates :name, :price, presence: true
  validates :price, :discount_price, numericality: {greater_than_or_equal_to: 0}
end
