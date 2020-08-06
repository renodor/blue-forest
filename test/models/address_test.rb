require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  def setup
    @address = addresses(:address1)
  end

  test 'valid address' do
    assert @address.valid?
  end

  test 'address must have street' do
    @address.street = nil
    assert_not @address.valid?
  end

  test 'address must have a district' do
    @address.district = nil
    assert_not @address.valid?
  end

  test 'address must have a latitude' do
    @address.latitude = nil
    assert_not @address.valid?
  end

  test 'address must have a longitude' do
    @address.longitude = nil
    assert_not @address.valid?
  end

  test 'address detail are not mandatory' do
    @address.detail = nil
    assert @address.valid?
  end

  test 'address model must have a DISTRICTS array constant' do
    assert_not_nil Address::DISTRICTS
    assert_not_empty Address::DISTRICTS
  end

  test 'address model must have a CORREGIMIENTOS hash constant' do
    assert_not_nil Address::CORREGIMIENTOS
    assert_not_empty Address::CORREGIMIENTOS
  end

  test 'address area must belong to the correct district' do
    @address.district = 'San Miguelito'
    assert_not @address.valid?

    @address.area = 'Amelia Denis de Icaza'
    assert @address.valid?
  end

  test 'google maps links' do
    assert @address.google_maps_link,
           "http://www.google.com/maps/place/#{@address.latitude},#{@address.longitude}"
  end
end
