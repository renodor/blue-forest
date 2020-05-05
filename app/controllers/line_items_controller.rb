class LineItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    # Find associated product
    chosen_product_variation = ProductVariation.find(params[:variation_id])

    # Find associated product variations
    current_cart = @current_cart

    # If cart already has this product variation then find the relevant line_item and iterate quantity otherwise create a new line_item for this product
    if current_cart.product_variations.include?(chosen_product_variation)
      # Find the line_item with the chosen_product variation
      @line_item = current_cart.line_items.find(chosen_product_variation)
      # Iterate the line_item's quantity by one
      @line_item.quantity += 1
    else
      @line_item = LineItem.new
      @line_item.cart = current_cart
      @line_item.product_variation = chosen_product_variation
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
