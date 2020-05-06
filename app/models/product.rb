class Product < ApplicationRecord
  has_many :product_variations, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories

  validates :name, presence: true
end
