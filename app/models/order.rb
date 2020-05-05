class Order < ApplicationRecord
  belongs_to :user
  belongs_to :fake_user, optional: true
  has_many :line_items, dependent: :destroy
end
