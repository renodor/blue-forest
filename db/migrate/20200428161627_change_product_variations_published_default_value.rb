class ChangeProductVariationsPublishedDefaultValue < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:product_variations, :published, true)
  end
end
