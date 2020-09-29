require 'test_helper'
require 'open-uri'

class ProductPhotoTest < ActiveSupport::TestCase
  def setup
    @product_photo = product_photos(:product_photo1)
  end

  test 'valid product photo' do
    assert @product_photo.valid?
  end

  test 'product photo can have many photos' do
    assert_equal @product_photo.photos.count, 2
  end
end
