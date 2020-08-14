require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase
  test 'valid product_categories' do
    product_category = ProductCategory.new
    product_category.product = products(:product1)
    product_category.category = categories(:parent_category)
    assert product_category.valid?
  end
end
