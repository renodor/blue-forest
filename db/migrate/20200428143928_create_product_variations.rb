class CreateProductVariations < ActiveRecord::Migration[6.0]
  def change
    create_table :product_variations do |t|
      t.references :product, null: false, foreign_key: true
      t.string :variation_name
      t.string :variation_type
      t.integer :quantity
      t.boolean :published

      t.timestamps
    end
  end
end
