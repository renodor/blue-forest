require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase
  test 'valid product_categories' do
    assert product_categories(:product_category).valid?
  end
end
