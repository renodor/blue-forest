class LineItemsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    # Find associated product
    chosen_product_variation = ProductVariation.find(params[:variation_id])

    # Additional security to check if there is stock available for this product (Normally it shouldn't appear on the PDP any whay if there is no stock)
    if chosen_product_variation.quantity > 0
      # Find associated product variations
      current_cart = @current_cart

      # If cart already has this product variation then find the relevant line_item and incrment quantity otherwise create a new line_item for this product
      if current_cart.product_variations.include?(chosen_product_variation)
        # Find the line_item with the chosen_product variation
        @line_item = current_cart.line_items.find_by(product_variation_id: chosen_product_variation.id)

        # making sure that there is stock available for this product regarding the quantity already present in the current cart
        if @line_item.quantity < @line_item.product_variation.quantity
          # Iterate the line_item's quantity by one
          @line_item.quantity += 1
        else
          flash.alert = "No se puede añadir más de este producto"
          # if it was added from home page, redirect to home page
          # else, redirect to product page
          if params[:atc_grid]
            redirect_to root_path
          else
            redirect_to product_path(chosen_product_variation.product)
          end
          return
        end
      else
        @line_item = LineItem.new
        @line_item.cart = current_cart
        @line_item.product_variation = chosen_product_variation
      end

      # Save and redirect to cart show path
      @line_item.save

      # Once line item created, put a params to trigger add to cart modal
      # and redirect back to home page (if it was added from home page)
      # or to pdp (if it was added from pdp)
      if params[:atc_grid]
        redirect_to root_path(chosen_product: chosen_product_variation.product.name, atc_modal: true)
      else
        redirect_to product_path(chosen_product_variation.product, atc_modal: true)
      end
      return
    end
    flash.alert = "No se puede añadir más de este producto"

    # if it was added from home page, redirect to home page
    # else, redirect to product page
    if params[:atc_grid]
      redirect_to root_path
    else
      redirect_to product_path(chosen_product_variation.product)
    end
  end

  def add_quantity
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity < @line_item.product_variation.quantity
      @line_item.quantity += 1
      @line_item.save
    else
      flash.alert = "No se puede añadir más de este producto"
    end
    redirect_to cart_path(@current_cart)
  end

  def reduce_quantity
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity > 1
      @line_item.quantity -= 1
    end
    @line_item.save
    redirect_to cart_path(@current_cart)
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    redirect_to cart_path(@current_cart)
  end

  # private

  # def line_item_params
  #   params.require(:line_item).permit(:quantity, :product_variation_id, :cart_id)
  # end
end
