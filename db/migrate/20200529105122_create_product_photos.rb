class CreateProductPhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :product_photos do |t|
      t.string :color
      t.boolean :main, default: false
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
