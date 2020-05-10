class FakeUser < ApplicationRecord
  has_many :orders
  has_many :addresses, dependent: :destroy

  before_destroy :remove_orders_foreign_key

  validates :first_name, :last_name, :phone, :email, presence: true

  private

  # When we delete an user we want its orders not to be deleted
  # we need this callback to avoid foreign key constraint
  def remove_orders_foreign_key
    self.orders.each do |order|
      order.update(user: nil)
    end
  end
end
