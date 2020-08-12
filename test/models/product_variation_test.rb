require 'test_helper'

class ProductVariationTest < ActiveSupport::TestCase
  def setup
    @product = products(:product1)
    @variation = product_variations(:product_variation1)
    @line_item = line_items(:line_item1)
  end

  test 'valid product variation' do
    assert @variation.valid?
  end

  test 'product variation should be published by default' do
    assert @variation.published
  end

  test 'product variation should have a published value (true or false)' do
    @variation.published = false
    assert @variation.valid?

    @variation.published = nil
    assert_not @variation.valid?
  end

  test 'product variation should have a quantity' do
    @variation.quantity = nil
    assert_not @variation.valid?
  end

  test 'product variation should have a price' do
    @variation.price = nil
    assert_not @variation.valid?
  end

  test 'product variation should have a size' do
    @variation.size = nil
    assert_not @variation.valid?
  end

  test 'product variation add name callback' do
    @variation.save
    assert_match "#{@variation.product.name}-#{@variation.size}", @variation.name

    @variation.update(color: 'red')
    assert_match "#{@variation.product.name}-#{@variation.size}-#{@variation.color}", @variation.name
  end

  test 'product variation price should be a number greater or equal to zero' do
    @variation.price = 'price'
    assert_not @variation.valid?
    @variation.price = -1
    assert_not @variation.valid?
    @variation.price = 0
    assert @variation.valid?
  end

  test 'product variation quantity should be a number greater or equal than 0' do
    @variation.quantity = 'q'
    assert_not @variation.valid?
    @variation.quantity = -1
    assert_not @variation.valid?
    @variation.quantity = 0
    assert @variation.valid?
  end

  test 'when destroy a product variation, its line items should be destroyed' do
    assert_difference 'LineItem.count', -2 do
      @variation.destroy
    end
  end
end
