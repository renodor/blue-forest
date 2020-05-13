class AddColumnsToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :sub_total, :decimal
    add_column :orders, :total_items, :decimal
    add_column :orders, :shipping, :decimal
    add_column :orders, :itbms, :decimal
    rename_column :orders, :total_amount, :total
  end
end
