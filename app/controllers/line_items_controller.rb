class LineItemsController < ApplicationController
  skip_before_action :authenticate_user!

  # TO DELETE > See SO solution to bypass that
  skip_before_action :verify_authenticity_token

  def create
    # Find associated product
    chosen_product_variation = ProductVariation.find(params[:variation_id])

    # Additional security to check if there is stock available for this product (Normally it shouldn't appear on the PDP any whay if there is no stock)
    if chosen_product_variation.quantity > 0
      # Find associated product variations
      current_cart = @current_cart

      # If cart already has this product variation then find the relevant line_item and increment quantity otherwise create a new line_item for this product
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

  # this action will be triggered by an AJAX request (by the js stimulus counter controller)
  # so it needs to respond a json
  def add_quantity
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity < @line_item.product_variation.quantity
      @line_item.quantity += 1
      @line_item.save
      # if quantity can be incremented send a json response with all current_cart info
      cart_info_json_response
    else
      # if not, send a json response with an error message
      respond_to do |format|
        format.json { render json: {
            can_change_quantity: false,
            error: "No se puede añadir más de este producto"
          }
        }
      end
    end
  end

  # this action will be triggered by an AJAX request (by the js stimulus counter controller)
  # so it needs to respond a json
  def reduce_quantity
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity > 1
      @line_item.quantity -= 1
    end
    @line_item.save
    # once quantity has been decreased send a json response with all current_cart info
    cart_info_json_response
  end

  # this action will be triggered by an AJAX request (by the js stimulus counter controller)
  # so it needs to respond a json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    cart_info_json_response
  end

  private

  # def line_item_params
  #   params.require(:line_item).permit(:quantity, :product_variation_id, :cart_id)
  # end

  # helper method to send a json response with all current_cart info
  def cart_info_json_response
    respond_to do |format|
      format.json { render json: {
          can_change_quantity: true,
          current_cart: @current_cart,
          total_items: @current_cart.total_items.to_i,
          sub_total: @current_cart.sub_total,
          shipping: @current_cart.shipping.to_i,
          itbms: @current_cart.itbms.to_f,
          total: @current_cart.total.to_f
        }
      }
    end
  end
end
