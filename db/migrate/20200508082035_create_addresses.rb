class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true
      t.references :fake_user, foreign_key: true
      t.string :street
      t.string :flat_number
      t.string :district
      t.text :detail
      t.string :city
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
