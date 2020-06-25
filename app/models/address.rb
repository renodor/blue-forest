class Address < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :fake_user, optional: true

  validates :street, :district, :city, :latitude, :longitude, presence: true

  private

  def google_maps_link
    "http://www.google.com/maps/place/#{self.latitude},#{self.longitude}"
  end
end
