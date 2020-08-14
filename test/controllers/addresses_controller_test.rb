require 'test_helper'

# rubocop:disable Metrics/ClassLength
class AddressesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @address1 = addresses(:address1)
    @address2 = addresses(:address2)
    @user = users(:user1)
    @fake_user = fake_users(:fake_user1)
  end

  test 'should get new for users, if user is signed in' do
    sign_in(@user)
    get new_user_address_path(@user)
    assert_template 'addresses/new'
    assert_response :success
  end

  test 'should get new for fake users, if user is not signed in' do
    get new_fake_user_address_path(@fake_user)
    assert_template 'addresses/new'
    assert_response :success
  end

  test 'create a valid user address if user is signed in' do
    sign_in(@user)
    assert_difference 'Address.count', 1 do
      post user_addresses_path(@user), params: {
        address: {
          street: 'street name',
          flat_number: '8B',
          district: 'Panamá',
          area: 'Bella Vista',
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
    assert_nil Address.last.fake_user
    # redirect to new order path for fake users
    assert_redirected_to new_user_order_path(@user)
  end

  test 'create a valid fake user address if user is not signed in' do
    assert_difference 'Address.count', 1 do
      post fake_user_addresses_path(@fake_user), params: {
        address: {
          street: 'street name',
          flat_number: '8B',
          district: 'Panamá',
          area: 'Bella Vista',
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
    assert_nil Address.last.user
    # redirect to new order path for fake users
    assert_redirected_to new_fake_user_order_path(@fake_user)
  end

  test "don't create address and render new if address creation is not valid" do
    assert_difference 'Address.count', 0 do
      post fake_user_addresses_path(@fake_user), params: {
        address: {
          street: 'street name'
        }
      }
    end
    # render new
    assert_template 'addresses/new'
  end

  test 'edit address for users' do
    sign_in(@user)
    get edit_user_address_path(@user, @address1)
    assert_template 'addresses/edit'
    assert_response :success
  end

  test 'edit address for fake users' do
    get edit_fake_user_address_path(@fake_user, @address2)
    assert_template 'addresses/edit'
    assert_response :success
  end

  test 'update a valid fake user address if user is not signed in' do
    patch fake_user_address_path(@fake_user, @address2), params: {
      address: {
        street: 'new street name'
      }
    }
    @address2.reload
    assert_equal @address2.street, 'new street name'
    assert_redirected_to new_fake_user_order_path(@fake_user)
  end

  test 'update a valid user address if user is signed in' do
    sign_in(@user)
    patch user_address_path(@user, @address1), params: {
      address: {
        street: 'new street name'
      }
    }
    @address1.reload
    assert_equal @address1.street, 'new street name'
    assert_redirected_to new_user_order_path(@user)
  end

  test "don't update address and render new if address update is not valid" do
    assert_difference 'Address.count', 0 do
      patch fake_user_address_path(@fake_user, @address2), params: {
        address: {
          district: 'invalid name'
        }
      }
    end
    # render new
    assert_template 'addresses/edit'
  end

  test 'redirect to dashboard if from_dashboard params is present' do
    sign_in(@user)
    patch user_address_path(@user, @address1, from_dashboard: true), params: {
      address: {
        street: 'new street name'
      }
    }
    assert_redirected_to dashboards_path
  end
end
# rubocop:enable Metrics/ClassLength
