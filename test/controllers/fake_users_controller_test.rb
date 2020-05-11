require 'test_helper'

class FakeUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get a new" do
    get new_fake_user_path
    assert_response :success
  end

  test "create fake user" do
    assert_difference 'FakeUser.count', 1 do
      post fake_users_path, params: { fake_user: {
        first_name: "Me",
        last_name: "Doobidoo",
        email: "me@doobidoo.com",
        phone: "+507 6666 6666"
        }
      }
    end
  end
end
