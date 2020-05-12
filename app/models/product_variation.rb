class ProductVariation < ApplicationRecord
  belongs_to :product
  has_many :line_items, dependent: :destroy

  validates :price, :quantity, :size, :name, presence: true
  validates :price, :quantity, numericality: {greater_than_or_equal_to: 0}
  validates :published, inclusion: { in: [true, false] }

  # automatically name the product variation (according to the product name)
  before_validation :add_name

  # each time there is a quantity change, check stock level
  before_save :check_stock_level, if: :will_save_change_to_quantity?

  # each time there is a publishing status change to on product variation,
  # check if the product has other product variations published
  after_commit :check_other_variations_stock_level, if: :saved_change_to_published?

  private

  def check_stock_level
    if self.quantity.zero?
      # if stock is down, unpublish product variation
      self.published = false
    end
  end

  def check_other_variations_stock_level
    product = self.product
    product.product_variations.each do |variation|
      # return without doing anything if at least one variation is published
      return if variation.published
    end

    # otherwise unpublish the product
    product.update(published: false)
  end

  def add_name
    self.name = "#{self.product.name}-#{self.size}"
  end
end
