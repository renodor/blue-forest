class RemoveAddressFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :address, :string
    remove_column :fake_users, :address, :string
  end
end
