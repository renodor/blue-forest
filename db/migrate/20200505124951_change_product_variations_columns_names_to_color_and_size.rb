class ChangeProductVariationsColumnsNamesToColorAndSize < ActiveRecord::Migration[6.0]
  def change
    rename_column :product_variations, :name, :color
    rename_column :product_variations, :value, :size
  end
end
