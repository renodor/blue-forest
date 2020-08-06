class Address < ApplicationRecord
  DISTRICTS = ['Panamá', 'San Miguelito'].freeze
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

  }.freeze

  belongs_to :user, optional: true
  belongs_to :fake_user, optional: true

  validates :district, inclusion: { in: DISTRICTS }
  validate :area_regarding_district
  validates :street, :city, :latitude, :longitude, presence: true

  def google_maps_link
    "http://www.google.com/maps/place/#{latitude},#{longitude}"
  end

  private

  # check that the area (corregimiento) correspond to the good district
  def area_regarding_district
    good_panama_disctricts = district == 'Panamá' && CORREGIMIENTOS[:panama].include?(area)
    good_sm_districts = district == 'San Miguelito' && CORREGIMIENTOS[:san_miguelito].include?(area)
    return if good_panama_disctricts || good_sm_districts

    errors.add(:area, ': por favor seleccionar uno en la lista')
  end

end
