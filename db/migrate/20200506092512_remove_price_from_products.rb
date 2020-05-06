class RemovePriceFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :price, :decimal
    remove_column :products, :discount_price, :decimal
  end
end
