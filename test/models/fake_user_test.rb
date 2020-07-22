require 'test_helper'

class FakeUserTest < ActiveSupport::TestCase
  def setup
    @fake_user = users(:user1)
  end

  test 'valid user' do
    assert @fake_user.valid?
  end

  test 'fake user must have a first name' do
    @fake_user.first_name = nil
    assert_not @fake_user.valid?
  end

  test 'fake user must have a last name' do
    @fake_user.last_name = nil
    assert_not @fake_user.valid?
  end

  test 'fake user must have an email' do
    @fake_user.email = nil
    assert_not @fake_user.valid?
  end

  test 'fake user must have a phone' do
    @fake_user.phone = nil
    assert_not @fake_user.valid?
  end

  test 'when destroy an fake user, its addresses should be destroyed' do
    assert_difference 'Address.count', -1 do
      @fake_user.destroy
    end
  end

  test 'fake user has many orders' do
    assert_equal @fake_user.orders.count, 2
  end
end
