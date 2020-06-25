class AddOrderToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :order, :integer
  end
end
