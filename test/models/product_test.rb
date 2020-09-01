require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = products(:product1)
  end

  test 'valid product' do
    assert @product.valid?
  end

  test 'product should have a name' do
    @product.name = ''
    assert_not @product.valid?
  end

  test 'product should be published by default' do
    assert @product.published
  end

  test 'when destroy a product, its variations should be destroyed' do
    assert_difference 'ProductVariation.count', -3 do
      @product.destroy
    end
  end

  test 'when destroy a product, its product_categories should be destroyed' do
    assert_difference 'ProductCategory.count', -1 do
      @product.destroy
    end
  end

  test 'can access product categories through product_categories' do
    @product.categories = [categories(:parent_category)]
    assert @product.categories.first.name, 'parent_category'
  end

  test 'when destroy a product, its product_favorites should be destroyed' do
    assert_difference 'ProductFavorite.count', -1 do
      @product.destroy
    end
  end

  test 'when destroy a product, its product_photos should be destroyed' do
    assert_difference 'ProductPhoto.count', -2 do
      @product.destroy
    end
  end

  test 'markdown to html converter callback' do
    @product.long_description = '**I am a bold text**'
    @product.save
    assert_match '<strong>I am a bold text</strong>', @product.long_description

    @product.long_description = "*item1\n*item2\n*item3\n"
    @product.save
    assert_match "<ul>\n<li>item1</li>\n<li>item2</li>\n<li>item3</li>\n<\/ul>\n",
                 @product.long_description

    @product.long_description = "\r\n"
    @product.save
    assert_match '<br>', @product.long_description
  end

  test 'define main color callback' do
    @product.save
    main_color = @product.product_photos.find_by(main: true).color
    assert_equal @product.main_color, main_color
  end
end
