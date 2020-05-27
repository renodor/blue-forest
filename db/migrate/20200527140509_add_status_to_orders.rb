class AddStatusToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :status, :string, default: 'confirmed'
  end
end
