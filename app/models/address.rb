class Address < ApplicationRecord
  belongs_to :user
  belongs_to :fake_user
end
