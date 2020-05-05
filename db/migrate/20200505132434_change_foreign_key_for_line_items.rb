class ChangeForeignKeyForLineItems < ActiveRecord::Migration[6.0]
  def change
    change_column_null :line_items, :order_id, true
  end
end
