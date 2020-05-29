class Product < ApplicationRecord
  has_many :product_variations, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :product_photos, dependent: :destroy

  validates :name, presence: true
  validates :published, inclusion: { in: [true, false] }
end
