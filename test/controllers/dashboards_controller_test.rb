require 'test_helper'
require 'open-uri'

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = users(:user1)

    product_photos(:product_photo2).photos.attach(
      [
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846867/744-500x500_q9y6wr.jpg'),
          filename: '1.png', content_type: 'image/jpg' },
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/861-500x500_s0fflw.jpg'),
          filename: '2.png', content_type: 'image/jpg' }
      ]
    )
  end

  test 'should have a dashboard' do
    sign_in(@user)
    get dashboards_path
    assert_template 'dashboards/dashboard'
    assert_response :success
  end

  test 'dashboard should redirect user if not logged in' do
    get dashboards_path
    assert_redirected_to new_user_session_path
  end

  test 'dashboard should redirect user if not admin' do
    # p ">>>>>>>>>>>>>>>>>>>>>>> #{@user.admin}"
    # sign_in(@user)
    # get dashboards_path
    # assert_redirected_to root_path
  end
end
