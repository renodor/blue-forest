class ChangeDescriptionToProducts < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :description, :short_description
    add_column :products, :long_description, :text
  end
end
