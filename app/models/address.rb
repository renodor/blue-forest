class Address < ApplicationRecord
  DISTRICTS = ['Panamá', 'San Miguelito']
  CORREGIMIENTOS = ['Bella Vista', 'Albrook', '11 de Octubre']

  belongs_to :user, optional: true
  belongs_to :fake_user, optional: true

  validates :area, inclusion: { in: CORREGIMIENTOS}
  validates :district, inclusion: { in: DISTRICTS}
  validates :street, :district, :area, :city, :latitude, :longitude, presence: true


  private

  def google_maps_link
    "http://www.google.com/maps/place/#{self.latitude},#{self.longitude}"
  end
end
