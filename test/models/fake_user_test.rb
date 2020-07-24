require 'test_helper'

class FakeUserTest < ActiveSupport::TestCase
  def setup
    @fake_user = fake_users(:fake_user1)
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

  test 'when destroy a fake user, its addresses should be destroyed' do
    assert_difference 'Address.count', -1 do
      @fake_user.destroy
    end
  end

  test 'fake user can have many orders' do
    assert_equal @fake_user.orders.count, 2
  end

  test 'when delete fake user, its order should not be deleted' do
    assert_no_difference 'Order.count' do
      @fake_user.destroy
    end
  end
end
