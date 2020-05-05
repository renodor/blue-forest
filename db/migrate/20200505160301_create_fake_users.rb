class CreateFakeUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :fake_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :address
      t.string :email

      t.timestamps
    end
  end
end
