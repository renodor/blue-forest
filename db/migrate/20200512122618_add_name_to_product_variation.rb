class AddNameToProductVariation < ActiveRecord::Migration[6.0]
  def change
    add_column :product_variations, :name, :string
  end
end
