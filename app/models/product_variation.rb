class ProductVariation < ApplicationRecord
  belongs_to :product, touch: true
  has_many :line_items, dependent: :destroy

  validates :price, :quantity, :size, presence: true
  validates :price, :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :published, inclusion: { in: [true, false] }

  # automatically name the product variation
  # which is the product name + size and color variations
  before_validation :add_name

  # each time there is a quantity change, check stock level
  # (callback commented since we want out of stock products to appear on frontend)
  # before_save :check_stock_level, if: :will_save_change_to_quantity?

  # each time there is a publishing status change to one product variation,
  # check if the product has other product variations published
  # (callback commented since we want out of stock products to appear on frontend)
  # after_commit :check_other_variations_stock_level, if: :saved_change_to_published?

  COLORS = {
    black: 'black',
    white: 'white',
    gray: '#b0b3b2',
    red: '#c73429',
    red_wine: '#4C0F13',
    blue: '#021eb7',
    light_blue: '#5dadd4',
    dark_blue: '#161D4C',
    green: '#4CAF50',
    orange: '#ff9234',
    yellow: '#ffbf3c',
    pink: '#f38b8b',
    brown: '#884b20',
    purple: '#c480d0',
    beige: '#F7D8A9'
  }.freeze

  private

  def add_name
    self.name = if color
                  "#{product.name}-#{size}-#{color}"
                else
                  "#{product.name}-#{size}"
                end
  end

  # (callback commented since we want out of stock products to appear on frontend)
  def check_stock_level
    return unless quantity.zero?

    # if stock is down, unpublish product variation
    self.published = false
  end

  # (callback commented since we want out of stock products to appear on frontend)
  def check_other_variations_stock_level
    product = self.product
    product.product_variations.each do |variation|
      # return true if at least one variation is published
      return true if variation.published
    end

    # otherwise unpublish the product
    product.update(published: false)
    false
  end
end
