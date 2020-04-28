class ChangeProductVariationsColumnsName < ActiveRecord::Migration[6.0]
  def change
    rename_column :product_variations, :variation_type, :name
    rename_column :product_variations, :variation_name, :value
  end
end
