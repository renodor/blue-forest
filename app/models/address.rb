class Address < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :fake_user, optional: true

  validates :street, :district, :detail, :city, :latitude, :longitude, presence: true
end
