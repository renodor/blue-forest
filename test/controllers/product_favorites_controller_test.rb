require 'test_helper'

class ProductFavoritesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
  end

  test 'create product favorite' do
    post line_items_path, params: {
      quantity: '1',
      variation_id: @variation.id
    }

    @current_cart = LineItem.last.cart

    assert_no_difference 'LineItem.count' do
      assert_difference 'LineItem.last.quantity', 1 do
        post add_quantity_line_item_path(LineItem.last.id, quantity: '1'), xhr: true
      end
    end

    assert_equal 'application/json; charset=utf-8', @response.content_type
    assert_equal expected_ajax_sucess_response.to_json, @response.body
  end

  test 'remove product from favorites' do

  end
end
