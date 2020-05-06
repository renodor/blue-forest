class AddPriceFromProductVariations < ActiveRecord::Migration[6.0]
  def change
    add_column :product_variations, :price, :decimal
    add_column :product_variations, :discount_price, :decimal
  end
end
