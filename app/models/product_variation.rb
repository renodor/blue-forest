class ProductVariation < ApplicationRecord
  belongs_to :product

  # validates :quantity, numericality: {greater_than_or_equal_to: 0}
  validates :published, presence: true
end
