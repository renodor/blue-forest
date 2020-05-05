class LinesItemsController < ApplicationController
  def create
    # Find associated product and current cart
    chosen_product = ProductVariation.find(params[:product_variation_id])
    current_cart = @current_cart

    # If cart already has this product then find the relevant line_item and iterate quantity otherwise create a new line_item for this product
    if current_cart.product_variations.include?(chosen_product)
      # Find the line_item with the chosen_product
      @line_item = current_cart.line_items.find(chosen_product)
      # Iterate the line_item's quantity by one
      @line_item.quantity += 1
    else
      @line_item = LineItem.new
      @line_item.cart = current_cart
      @line_item.product_variation = chosen_product
    end

    # Save and redirect to cart show path
    @line_item.save
    redirect_to cart_path(current_cart)
  end

  private
    def line_item_params
      params.require(:line_item).permit(:quantity,:product_id, :cart_id)
    end
end
