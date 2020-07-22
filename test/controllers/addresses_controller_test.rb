require 'test_helper'

class AddressesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user1)
    @fake_user = fake_users(:fake_user1)
  end

  test 'should get new for users, if user is signed in' do
    sign_in(@user)
    get new_user_address_path(@user)
    assert_response :success
  end

  test 'should get new for fake users, if user is not signed in' do
    get new_fake_user_address_path(@fake_user)
    assert_response :success
  end

  test 'create a valid user address if user is signed in' do
    sign_in(@user)
    assert_difference 'Address.count', 1 do
      post user_addresses_path(@user), params: {
        address: {
          street: 'street name',
          flat_number: '8B',
          district: 'Cool district',
          detail: 'amazing details',
          city: 'Panama',
          latitude: 10,
          longitude: -100
        }
      }
    end
    # new address should belong to user
    assert_equal Address.last.user, @user
    # fake user should be nil
    assert_not Address.last.fake_user
    # redirect to new order path for fake users
    assert_redirected_to new_user_order_path(@user)
  end

  test 'create a valid fake user address if user is not signed in' do
    assert_difference 'Address.count', 1 do
      post fake_user_addresses_path(@fake_user), params: {
        address: {
          street: 'street name',
          flat_number: '8B',
          district: 'Cool district',
          detail: 'amazing details',
          city: 'Panama',
          latitude: 10,
          longitude: -100
        }
      }
    end
    # new address should belong to fake user
    assert_equal Address.last.fake_user, @fake_user
    # user should be nil
    assert_not Address.last.user
    # redirect to new order path for fake users
    assert_redirected_to new_fake_user_order_path(@fake_user)
  end
end
