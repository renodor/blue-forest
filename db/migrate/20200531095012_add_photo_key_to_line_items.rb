class AddPhotoKeyToLineItems < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :photo_key, :string
  end
end
