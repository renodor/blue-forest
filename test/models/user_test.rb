require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
  end

  test "valid user" do
    assert @user.valid?
  end

  test "user must have a first name" do
    @user.first_name = nil
    assert_not @user.valid?
  end


  test "user must have a last name" do
    @user.last_name = nil
    assert_not @user.valid?
  end

  test "user must have an email" do
    @user.email = nil
    assert_not @user.valid?
  end

  test "user must have a phone" do
    @user.phone = nil
    assert_not @user.valid?
  end

  test 'when destroy an user, its addresses should be destroyed' do
    assert_difference 'Address.count', -1 do
      @user.destroy
    end
  end

  test 'user has many orders' do
    assert_equal @user.orders.count, 2
  end
end
