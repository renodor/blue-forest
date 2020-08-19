require 'test_helper'

class FakeUsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @fake_user = fake_users(:fake_user1)
  end

  test 'should get a new' do
    get new_fake_user_path
    assert_template 'fake_users/new'
    assert_response :success
  end

  test 'create valid fake user' do
    assert_difference 'FakeUser.count', 1 do
      post fake_users_path, params: {
        fake_user: {
          first_name: 'Me',
          last_name: 'Doobidoo',
          email: 'me@doobidoo.com',
          phone: '+507 6666 6666'
        }
      }
    end
    assert_redirected_to new_fake_user_address_path(FakeUser.last)
  end

  test "don't create invalid fake user and render new" do
    assert_no_difference 'FakeUser.count' do
      post fake_users_path, params: { fake_user: { first_name: '' } }
    end
    assert_template 'fake_users/new'
  end

  test 'edit fake user' do
    get edit_fake_user_path(@fake_user)
    assert_template 'fake_users/edit'
    assert_response :success
  end

  test 'update valid fake user' do
    patch fake_user_path(@fake_user), params: {
      fake_user: {
        first_name: 'new name'
      }
    }
    @fake_user.reload
    assert_equal @fake_user.first_name, 'new name'
    assert_redirected_to new_fake_user_order_path(@fake_user)
  end
end
