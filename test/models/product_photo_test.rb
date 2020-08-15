require 'test_helper'
require 'open-uri'

class ProductPhotoTest < ActiveSupport::TestCase
  def setup
    @product_photo = product_photos(:product_photo1)
    @product_photo.photos.attach(
      [
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846867/744-500x500_q9y6wr.jpg'),
          filename: '1.png', content_type: 'image/jpg' },
        { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/861-500x500_s0fflw.jpg'),
          filename: '2.png', content_type: 'image/jpg' }
      ]
    )
    @product_photo.save
  end

  test 'valid product photo' do
    assert @product_photo.valid?
  end

  test 'product photo can have many photos' do
    assert_equal @product_photo.photos.count, 2
  end
end
