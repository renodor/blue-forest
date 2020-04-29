require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  test "Home page should have a carousel and product grid" do
    visit root_url
    assert_selector "div#hp-carousel"
    assert_selector "div.products"
  end
end
