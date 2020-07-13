class Order < ApplicationRecord
  STATUS = %w[confirmed pick_pack shipping delivered].freeze
  belongs_to :user, optional: true
  belongs_to :fake_user, optional: true
  has_many :line_items, dependent: :destroy
  has_many :product_variations, through: :line_items

  validates :sub_total, :total_items, :shipping, :itbms, :total, presence: true
  validates :status, inclusion: { in: STATUS, message:
    ': Please choose between confirmed, pick_pack, shipping, delivered' }
end
