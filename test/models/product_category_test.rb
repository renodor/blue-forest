require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase
  def setup
    @product = products(:product1)
    @category = categories(:parent_category)
    @product_category = product_categories(:product_category)
  end

  test "valid product_categories" do
    assert @product_category
  end
end
