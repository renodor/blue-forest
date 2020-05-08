class FakeUser < ApplicationRecord
  has_many :orders
  has_many :addresses, dependent: :destroy
end
