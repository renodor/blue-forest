class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :fake_user, optional: true
  has_many :line_items, dependent: :destroy
  has_many :product_variations, through: :line_items

  validates :sub_total, :total_items, :shipping, :itbms, :total, presence: true
end
