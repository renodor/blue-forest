class ProductVariation < ApplicationRecord
  belongs_to :product
  has_many :line_items, dependent: :destroy

  validates :price, :quantity, :size, presence: true
  validates :price, :quantity, numericality: {greater_than_or_equal_to: 0}

  before_save :check_quantity, if: :will_save_change_to_quantity?

  private

  def check_quantity
    if self.quantity.zero?
      self.published = false
    end
  end
end
