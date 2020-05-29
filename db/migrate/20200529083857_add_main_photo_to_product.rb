class AddMainPhotoToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :main_photo_key, :string
  end
end
