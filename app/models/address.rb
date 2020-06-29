class Address < ApplicationRecord
  DISTRICTS = ['Panamá', 'San Miguelito']
  CORREGIMIENTOS = {
    panama: [
      '24 de Diciembre',
      'Alcalde Diaz',
      'Ancón',
      'Bella Vista',
      'Betania',
      'Calidonia',
      'Chilibre',
      'Curundú',
      'El Chorrillo',
      'Ernesto Córdova Campos',
      'Juan Diaz',
      'Las Cumbres',
      'Las Mañanitas',
      'Pacora',
      'Parque Lefevre',
      'Pedregal',
      'Pueblo Nuevo',
      'Rio Abajo',
      'San Felipe',
      'San Francisco',
      'San Martin',
      'Santa Ana Tocumen'
    ],
    san_miguelito: [
      'Amelia Denis de Icaza',
      'Arnulfo Arias',
      'Belisario Frías',
      'Belisario Porras',
      'Jose Domingo Espinar',
      'Mateo Iturralde',
      'Omar Torrijos',
      'Rufina Alfaro',
      'Victoriano Lorenzo'
    ]

  }

  belongs_to :user, optional: true
  belongs_to :fake_user, optional: true

  validates :district, inclusion: { in: DISTRICTS }
  validate :area_regarding_district
  validates :street, :city, :latitude, :longitude, presence: true


  private

  def area_regarding_district
    if district == 'Panamá' && !CORREGIMIENTOS[:panama].include?(area) || district == 'San Miguelito' && !CORREGIMIENTOS[:san_miguelito].include?(area)
      errors.add(:area, "Por favor seleccionar un Corregimiento en la lista")
    end
  end

  def google_maps_link
    "http://www.google.com/maps/place/#{self.latitude},#{self.longitude}"
  end
end
