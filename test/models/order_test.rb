require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = orders(:order1)
    @order2 = orders(:order2)
  end

  test "valid order with fake user" do
    assert @order.valid?
  end

  test "valid order with user" do
    assert @order.valid?
  end

  # test 'when destroy an order, its line_items should be destroyed' do
  #   assert_difference 'LineItem.count', 0 do
  #     @order.destroy
  #   end
  # end
end
