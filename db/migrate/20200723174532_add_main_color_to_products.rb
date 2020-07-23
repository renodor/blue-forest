class AddMainColorToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :main_color, :string
  end
end
