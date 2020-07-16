class LineItemsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    # Find associated product variation
    @chosen_product_variation = ProductVariation.find(params[:variation_id])

    # Check if there is enough stock available for the quantity the user wants to buy
    if @chosen_product_variation.quantity >= params[:quantity].to_i

      # If cart already has this product variation then find the relevant line_item
      # and increment quantity otherwise create a new line_item for this product
      if @current_cart.product_variations.include?(@chosen_product_variation)
        unless increment_existing_line_item
          redirect_to_correct_path
          return
        end
      else
        create_new_line_item
        @line_item = LineItem.new
        @line_item.cart = @current_cart
        @line_item.product_variation = @chosen_product_variation
        @line_item.quantity = params[:quantity].to_i
      end

      @line_item.save
      redirect_to_correct_path(true)
      return
    end
    redirect_to_correct_path
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

  def increment_existing_line_item
    # Find the line_item with the chosen_product variation
    @line_item = @current_cart.line_items.find_by(product_variation_id: @chosen_product_variation.id)
    # making sure that there is stock available for this product
    # regarding the quantity already present in the current cart
    if (@line_item.quantity + params[:quantity].to_i) <= @line_item.product_variation.quantity
      # Iterate the line_item's quantity by the quantity the user wants to buy
      @line_item.quantity += params[:quantity].to_i
    else
      false
    end
  end

  # method that redirect to the correct path after creating (or trying to create) a new line item
  # if atc_modal param is present it means line item was successfully created
  # if not, we trigger a flash alert message
  def redirect_to_correct_path(atc_modal = nil)
    flash.alert = 'No hay suficiente stock de este producto' unless atc_modal
    # if atc_from_grid param is present, product was added from a grid page (hp, search, category)
    # in that case we need to manually reconstruct the url and its query to redirect back the user
    # (built in redirect_back rails method doesn't help because you can't add custom params to it)
    if params[:atc_from_grid]
      # the previous url is stored in the :full_path params
      uri = URI(params[:full_path])
      # we need to construct queries (in order not to loose existing ones and to add custome ones)
      queries = construct_uri_queries(uri, atc_modal)
      # finally reconstruct the complete path and redirect
      redirect_to "#{uri.path}?#{queries}"
    else
      # if product was added from a pdp, just trigger atc_modal and redirect to pdp
      redirect_to product_path(@chosen_product_variation.product, atc_modal: atc_modal)
    end
  end

  # method to construct uri queries without losing existing ones
  def construct_uri_queries(uri, atc_modal)
    # if there are actually queries, we use the URI Module to convert queries to hash,
    # we add our custom queries and we encode the hash to query again
    if uri.query
      hash_uri = Hash[URI.decode_www_form(uri.query)]
      hash_uri['chosen_product'] = @chosen_product_variation.product.name
      atc_modal ? hash_uri['atc_modal'] = true : hash_uri.delete('atc_modal')
      URI.encode_www_form(hash_uri)
    else
      # if there is no queries, we just add the queries we need
      "chosen_product=#{@chosen_product_variation.product.name}#{'&atc_modal=true' if atc_modal}"
    end
  end

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
