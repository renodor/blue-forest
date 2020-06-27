class AddAreaToAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses, :area, :string
  end
end
