require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @parent_category = categories(:parent_category)
    @child_category = categories(:child_category)
  end

  test 'valid category' do
    assert @parent_category.valid?
  end

  test 'category should have a name' do
    @parent_category.name = ''
    assert_not @parent_category.valid?
  end

  test 'categories can have a parent/children relation' do
    assert @child_category.valid?
    assert_equal @child_category.parent, @parent_category
    assert_includes @parent_category.children, @child_category
  end

  test 'parent category can have many children categories' do
    assert_operator @parent_category.children.length, :>, 1
  end

  test 'when destroy a category, its product_categories should be destroyed' do
      assert_difference 'ProductCategory.count', -1 do
        @parent_category.destroy
      end
  end

  test 'when destroy a category, products are not destroyed' do
      assert_no_difference 'Product.count' do
        @parent_category.destroy
      end
  end
end
