class LineItemsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    # Find associated product variation
    chosen_product_variation = ProductVariation.find(params[:variation_id])

    # Check if there is enough stock available for the quantity the user wants to buy
    if chosen_product_variation.quantity >= params[:quantity].to_i

      current_cart = @current_cart

      # If cart already has this product variation then find the relevant line_item
      # and increment quantity otherwise create a new line_item for this product
      if current_cart.product_variations.include?(chosen_product_variation)
        # Find the line_item with the chosen_product variation
        @line_item = current_cart.line_items.find_by(product_variation_id: chosen_product_variation.id)

        # making sure that there is stock available for this product
        # regarding the quantity already present in the current cart
        if (@line_item.quantity + params[:quantity].to_i) <= @line_item.product_variation.quantity
          # Iterate the line_item's quantity by the quantity the user wants to buy
          @line_item.quantity += params[:quantity].to_i
        else
          flash.alert = 'No hay suficiente stock de este producto'
          # if it was added from home page, redirect to home page
          # else, redirect to product page
          if params[:atc_grid]
            redirect_to params[:atc_grid]
          else
            redirect_to product_path(chosen_product_variation.product)
          end
          return
        end
      else
        @line_item = LineItem.new
        @line_item.cart = current_cart
        @line_item.product_variation = chosen_product_variation
        @line_item.quantity = params[:quantity].to_i
      end

      @line_item.save

      # Once line item created, put a params to trigger add to cart modal
      # and redirect back to pdp (if it was added from pdp)
      # or to a specific page (if it was added from a product grid)
      if params[:atc_grid]
        url_parameters = "atc_modal=true&chosen_product=#{chosen_product_variation.product.name}"
        # if it was added from a product grid, we need to rebuild the url to redirect back correctly
        # (the redirect_back rails method doesn't help because you can't add custom parameter to it)
        # the previous url is stored in the params[:atc_grid]
        # if the url already has url params (if it contains a "?"),
        # we need to happens our params to the existing ones
        # if not, we just add our parameters to the url
        if params[:atc_grid].match?(/\?/)
          redirect_to "#{params[:atc_grid]}&#{url_parameters}"
        else
          redirect_to "#{params[:atc_grid]}?#{url_parameters}"
        end
      else
        redirect_to product_path(chosen_product_variation.product, atc_modal: true)
      end
      return
    end
    flash.alert = 'No hay suficiente stock de este producto'

    # if it was added from home page, redirect to home page
    # else, redirect to product page
    if params[:atc_grid]
      redirect_to params[:atc_grid]
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
        format.json do
          render json: {
            can_change_quantity: false,
            error: 'No se puede añadir más de este producto'
          }
        end
      end
    end
  end

  # this action will be triggered by an AJAX request (by the js stimulus counter controller)
  # so it needs to respond a json
  def reduce_quantity
    @line_item = LineItem.find(params[:id])
    @line_item.quantity -= 1 if @line_item.quantity > 1
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
      format.json do
        render json: {
          can_change_quantity: true,
          current_cart: @current_cart,
          total_items: @current_cart.total_items.to_i,
          sub_total: @current_cart.sub_total,
          shipping: @current_cart.shipping.to_f,
          itbms: @current_cart.itbms.to_f,
          total: @current_cart.total.to_f
        }
      end
    end
  end
end
