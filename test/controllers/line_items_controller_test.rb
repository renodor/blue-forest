require 'test_helper'
require 'open-uri'
require 'json'

# rubocop:disable Metrics/ClassLength
class LineItemsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @current_cart = carts(:cart1)
    @variation = product_variations(:product_variation1)

    product_photos(:product_photo1).photos.attach(
      [
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846867/744-500x500_q9y6wr.jpg'),
          filename: '1.png', content_type: 'image/jpg' },
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/861-500x500_s0fflw.jpg'),
          filename: '2.png', content_type: 'image/jpg' }
      ]
    )
  end

  # rubocop:disable Layout/LineLength
  def expected_ajax_sucess_response
    {
      can_change_quantity: true,
      current_cart: @current_cart,
      total_items: @current_cart.total_items.to_i,
      sub_total: ActionController::Base.helpers.number_to_currency(@current_cart.sub_total, precision: 2),
      shipping: ActionController::Base.helpers.number_to_currency(@current_cart.shipping, precision: 2, unit: ''),
      itbms: ActionController::Base.helpers.number_to_currency(@current_cart.itbms, precision: 2),
      total: ActionController::Base.helpers.number_to_currency(@current_cart.total, precision: 2)
    }
  end
  # rubocop:enable Layout/LineLength

  def expected_ajax_error_response
    {
      can_change_quantity: false,
      error: 'No se puede añadir más de este producto'
    }
  end

  test 'create valid line item from pdp' do
    assert_difference 'LineItem.count', 1 do
      post line_items_path, params: {
        quantity: '1',
        variation_id: @variation.id
      }
    end
    assert_redirected_to product_path(@variation.product, atc_modal: true)
  end

  test 'create valid line item from hp with other custom params' do
    url = '/'
    other_params = 'param1=query&param2=query2'
    full_path = "#{url}?#{other_params}"
    product_name = @variation.product.name

    assert_difference 'LineItem.count', 1 do
      post line_items_path, params: {
        atc_from_grid: true,
        full_path: full_path,
        quantity: '1',
        variation_id: @variation.id
      }
    end
    # assert_redirected_to root_path(chosen_product: @variation.product.name, atc_modal: true)
    assert_redirected_to "#{full_path}&chosen_product=#{product_name}&atc_modal=true"
  end

  test 'create valid line item from search page with other custom params
        (including atc_modal that should not be repeated)' do
    url = '/search'
    other_params = 'query=product&atc_modal=true'
    full_path = "#{url}?#{other_params}"
    product_name = @variation.product.name

    assert_difference 'LineItem.count', 1 do
      post line_items_path, params: {
        atc_from_grid: true,
        full_path: full_path,
        quantity: '1',
        variation_id: @variation.id
      }
    end
    assert_redirected_to "#{full_path}&chosen_product=#{product_name}"
  end

  test 'create invalid line item (not enough stock)' do
    assert_no_difference 'LineItem.count' do
      post line_items_path, params: {
        quantity: @variation.quantity + 1,
        variation_id: @variation.id
      }
    end
    assert_equal flash.alert, 'No hay suficiente stock de este producto'
    assert_redirected_to product_path(@variation.product)
  end

  test 'create valid line item (with just enough stock)' do
    assert_difference 'LineItem.count', 1 do
      post line_items_path, params: {
        quantity: @variation.quantity,
        variation_id: @variation.id
      }
    end
    assert_equal LineItem.last.quantity, 10
    assert_redirected_to product_path(@variation.product, atc_modal: true)
  end

  test 'add quantity to an existing line item' do
    post line_items_path, params: {
      quantity: '1',
      variation_id: @variation.id
    }

    @current_cart = LineItem.last.cart

    assert_no_difference 'LineItem.count' do
      assert_difference 'LineItem.last.quantity', 1 do
        post line_items_path, params: {
          quantity: '1',
          variation_id: @variation.id
        }
      end
    end
    assert_redirected_to product_path(@variation.product, atc_modal: true)
  end

  test 'try to add quantity to an existing line item
        (with not enough stock because already too much on the line item side)' do
    post line_items_path, params: {
      quantity: @variation.quantity,
      variation_id: @variation.id
    }

    @current_cart = LineItem.last.cart

    assert_no_difference 'LineItem.count' do
      assert_no_difference 'LineItem.last.quantity' do
        post line_items_path, params: {
          quantity: '1',
          variation_id: @variation.id
        }
      end
    end
    assert_equal flash.alert, 'No hay suficiente stock de este producto'
    assert_redirected_to product_path(@variation.product)
  end

  test 'try to add quantity to an existing line item
        (with not enough stock too much on the new line item)' do
    post line_items_path, params: {
      quantity: '1',
      variation_id: @variation.id
    }

    @current_cart = LineItem.last.cart

    assert_no_difference 'LineItem.count' do
      assert_no_difference 'LineItem.last.quantity' do
        post line_items_path, params: {
          quantity: @variation.quantity,
          variation_id: @variation.id
        }
      end
    end
    assert_equal flash.alert, 'No hay suficiente stock de este producto'
    assert_redirected_to product_path(@variation.product)
  end

  test 'add quantity to an existing line item from the cart with an AJAX request' do
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

  test 'remove quantity to an existing line item from the cart with an AJAX request' do
    post line_items_path, params: {
      quantity: '2',
      variation_id: @variation.id
    }

    @current_cart = LineItem.last.cart

    assert_no_difference 'LineItem.count' do
      assert_difference 'LineItem.last.quantity', -1 do
        post reduce_quantity_line_item_path(LineItem.last.id, quantity: '1'), xhr: true
      end
    end

    assert_equal 'application/json; charset=utf-8', @response.content_type
    assert_equal expected_ajax_sucess_response.to_json, @response.body
  end

  test 'try to add quantity to an existing line item from the cart with an AJAX request
        (with not enough stock)' do
    post line_items_path, params: {
      quantity: @variation.quantity,
      variation_id: @variation.id
    }

    @current_cart = LineItem.last.cart

    assert_no_difference 'LineItem.count' do
      assert_no_difference 'LineItem.last.quantity' do
        post add_quantity_line_item_path(LineItem.last.id, quantity: '1'), xhr: true
      end
    end

    assert_equal 'application/json; charset=utf-8', @response.content_type
    assert_equal expected_ajax_error_response.to_json, @response.body
  end

  test 'destroy a line item from the cart with an AJAX request' do
    post line_items_path, params: {
      quantity: '2',
      variation_id: @variation.id
    }

    @current_cart = LineItem.last.cart

    assert_difference 'LineItem.count', -1 do
      delete line_item_path(LineItem.last.id), xhr: true
    end

    assert_equal 'application/json; charset=utf-8', @response.content_type
    assert_equal expected_ajax_sucess_response.to_json, @response.body
  end
end
# rubocop:enable Metrics/ClassLength
