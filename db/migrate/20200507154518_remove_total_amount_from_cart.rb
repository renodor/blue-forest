class RemoveTotalAmountFromCart < ActiveRecord::Migration[6.0]
  def change
    remove_column :carts, :total_amount, :decimal
  end
end
