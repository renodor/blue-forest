class ChangeUserIdNullValueForOrders < ActiveRecord::Migration[6.0]
  def change
    change_column_null :orders, :user_id, true
  end
end
