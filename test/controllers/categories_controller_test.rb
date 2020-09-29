require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test 'category should get show' do
    category = categories(:parent_category)
    get category_url(category)
    assert_template 'categories/show'
    assert_response :success
  end
end
