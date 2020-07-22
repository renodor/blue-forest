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

  test 'address must have details' do
    @address.detail = nil
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
end
