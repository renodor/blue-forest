require 'test_helper'
require 'open-uri'

# rubocop:disable Metrics/ClassLength
class DashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = users(:user1)
    @user.update(admin: true)

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

  test 'product creation tool should redirect user if not looged in' do
    get product_creation_path
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'product creation tool should redirect user if not admin' do
    @user.update(admin: false)
    sign_in(@user)
    get product_creation_path
    assert_equal flash[:alert], 'Need admin rights to create products'
    assert_redirected_to root_path
  end

  test 'product creation tool should accept admin users' do
    sign_in(@user)
    get product_creation_path
    assert flash.empty?
    assert_response :success
  end

  # rubocop:disable Metrics/BlockLength
  test 'product creation tool whith a product without colors' do
    sign_in(@user)
    assert_difference 'Product.count', 1 do
      post product_creation_path, params: product_without_color_params
    end

    assert_equal flash[:notice], 'Product Created'
    assert_redirected_to product_creation_path

    product = Product.last
    variations = product.product_variations
    product_photos = product.product_photos

    assert_equal product.name, 'new product'
    assert_equal product.short_description, 'short description'
    assert_equal product.long_description, 'long description'
    assert product.published
    assert_equal variations.count, 2

    assert_nil variations[0].color
    assert_equal variations[0].size, 'M'
    assert_equal variations[0].price, 10
    assert_not variations[0].discount_price
    assert_equal variations[0].quantity, 10

    assert_nil variations[1].color
    assert_equal variations[1].size, 'L'
    assert_equal variations[1].price, 20.5
    assert_equal variations[1].discount_price, 19
    assert_equal variations[1].quantity, 20

    assert_equal product_photos.count, 1
    assert_equal product_photos[0].photos.count, 2
    assert_not product_photos[0].color
    assert product_photos[0].main
  end

  test 'product creation tool whith a product with colors' do
    sign_in(@user)
    assert_difference 'Product.count', 1 do
      post product_creation_path, params: product_with_colors_params
    end

    assert_equal flash[:notice], 'Product Created'
    assert_redirected_to product_creation_path

    product = Product.last
    variations = product.product_variations
    product_photos = product.product_photos

    assert_equal product.name, 'new product with colors'
    assert_equal product.short_description, 'short description'
    assert_equal product.long_description, 'long description'
    assert product.published
    assert_equal variations.count, 4

    assert_equal variations[0].color, 'red'
    assert_equal variations[0].size, 'XL'
    assert_equal variations[0].price, 10.2
    assert_equal variations[0].discount_price, 8.5
    assert_equal variations[0].quantity, 1

    assert_equal variations[1].color, 'red'
    assert_equal variations[1].size, 'S'
    assert_equal variations[1].price, 20.5
    assert_not variations[1].discount_price
    assert_equal variations[1].quantity, 1000

    assert_equal variations[2].color, 'blue'
    assert_equal variations[2].size, 'XL'
    assert_equal variations[2].price, 11
    assert_not variations[2].discount_price
    assert_equal variations[2].quantity, 20

    assert_equal variations[3].color, 'blue'
    assert_equal variations[3].size, 'M'
    assert_equal variations[3].price, 1000
    assert_equal variations[3].discount_price, 999
    assert_equal variations[3].quantity, 30

    assert_equal product_photos.count, 2
    assert_equal product_photos[0].photos.count, 2
    assert_equal product_photos[0].color, 'red'
    assert product_photos[0].main

    assert_equal product_photos[1].photos.count, 1
    assert_equal product_photos[1].color, 'blue'
    assert_not product_photos[1].main
  end
  # rubocop:enable Metrics/BlockLength

  # rubocop:disable Metrics/MethodLength
  def product_without_color_params
    {
      name: 'new product',
      short_description: 'short description',
      long_description: 'long description',
      published: 'true',
      product_type: 'without_colors',
      color_variations: [
        {
          color: 'unique',
          size_variations: [
            {
              size: 'M',
              price: '10',
              discount_price: '',
              quantity: '10'
            },
            {
              size: 'L',
              price: '20.5',
              discount_price: '19',
              quantity: '20'
            }
          ],
          photos: [
            { photo: fixture_file_upload('files/product_photo1.jpg'),
              main: 'true' },
            { photo: fixture_file_upload('files/product_photo2.jpg') }
          ]
        }
      ]
    }
  end

  def product_with_colors_params
    {
      name: 'new product with colors',
      short_description: 'short description',
      long_description: 'long description',
      published: 'true',
      product_type: 'with_colors',
      color_variations: [
        {
          color: 'red',
          size_variations: [
            {
              size: 'XL',
              price: '10.2',
              discount_price: '8.5',
              quantity: '1'
            },
            {
              size: 'S',
              price: '20.5',
              discount_price: '',
              quantity: '1000'
            }
          ],
          photos: [
            { photo: fixture_file_upload('files/product_photo1.jpg'),
              main: 'true' },
            { photo: fixture_file_upload('files/product_photo1.jpg') }
          ]
        },
        {
          color: 'blue',
          size_variations: [
            {
              size: 'XL',
              price: '11',
              discount_price: '',
              quantity: '20'
            },
            {
              size: 'M',
              price: '1000',
              discount_price: '999',
              quantity: '30'
            }
          ],
          photos: [
            { photo: fixture_file_upload('files/product_photo2.jpg') }
          ]
        }
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
