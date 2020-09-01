require 'test_helper'
require 'open-uri'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @product = products(:product1)
    product_photo = product_photos(:product_photo1)
    product_photo.photos.attach(
      [
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846867/744-500x500_q9y6wr.jpg'),
          filename: '1.png', content_type: 'image/jpg' },
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/861-500x500_s0fflw.jpg'),
          filename: '2.png', content_type: 'image/jpg' }
      ]
    )
  end

  test 'should get products index' do
    get products_path
    assert_template 'layouts/homepage'
    assert_response :success
  end

  test 'should get product show' do
    get product_path(@product)
    assert_template 'layouts/pdp'
    assert_response :success
  end
end
