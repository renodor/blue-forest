require 'test_helper'

class HomeTest < ActionDispatch::IntegrationTest
  test "Home page should have a carousel and product grid" do
    get root_path
    assert_select "div#hp-carousel"
    assert_select "div.products"
  end
end
