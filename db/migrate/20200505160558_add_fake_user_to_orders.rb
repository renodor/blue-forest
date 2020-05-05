class AddFakeUserToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :fake_user, foreign_key: true
  end
end
