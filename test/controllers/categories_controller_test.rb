require 'test_helper'
require 'open-uri'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test 'category should get show' do
    category = categories(:parent_category)

    # need to manually attach photos to the products of the category
    # otherwise the view returns 500 error
    product_photo = ProductPhoto.new
    product_photo.product = products(:product1)
    product_photo.photos.attach(
      [
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846867/744-500x500_q9y6wr.jpg'),
          filename: '1.png', content_type: 'image/jpg' },
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/861-500x500_s0fflw.jpg'),
          filename: '2.png', content_type: 'image/jpg' }
      ]
    )
    get category_url(category)
    assert_template 'categories/show'
    assert_response :success
  end
end
