class LineItemsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_line_item, only: %i[reduce_quantity destroy]

  def create
    # Find associated product variation
    @product_variation = ProductVariation.find(params[:variation_id])

    # Check if there is enough stock available for the quantity the user wants to buy
    redirect_to_correct_path and return unless @product_variation.quantity >= params[:quantity].to_i

    # If cart already has this product variation then find the relevant line_item
    # and increment quantity otherwise create a new line_item for this product
    if find_line_item
      redirect_to_correct_path and return unless add_quantity
    else
      create_new_line_item
    end
    @line_item.save
    redirect_to_correct_path(true)
  end

  def create_new_line_item
    @line_item = LineItem.new
    @line_item.cart = @current_cart
    @line_item.product_variation = @product_variation
    @line_item.quantity = params[:quantity].to_i
  end

  # this action will be triggered by an AJAX request (by the js stimulus counter controller)
  # so it needs to respond a json
  def add_quantity
    find_line_item unless @line_item
    quantity_to_add = params[:quantity] ? params[:quantity].to_i : 1
    if (@line_item.quantity + quantity_to_add) <= @line_item.product_variation.quantity
      @line_item.quantity += quantity_to_add
      @line_item.save
      # if quantity can be incremented send a json response with all current_cart info
      request.xhr? ? cart_info_json_response : true
    else
      request.xhr? ? error_json_response : false
    end
  end

  # this action will be triggered by an AJAX request (by the js stimulus counter controller)
  # so it needs to respond a json
  def reduce_quantity
    @line_item.quantity -= 1 if @line_item.quantity > 1
    @line_item.save
    # once quantity has been decreased send a json response with all current_cart info
    cart_info_json_response
  end

  # this action will be triggered by an AJAX request (by the js stimulus counter controller)
  # so it needs to respond a json
  def destroy
    @line_item.destroy
    cart_info_json_response
  end

  private

  def find_line_item
    if @product_variation && @current_cart.product_variations.include?(@product_variation)
      @line_item = @current_cart.line_items.find_by(product_variation_id: @product_variation.id)
    elsif params[:id]
      @line_item = LineItem.find(params[:id])
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
      redirect_to product_path(@product_variation.product, atc_modal: atc_modal)
    end
  end

  # method to construct uri queries without losing existing ones
  def construct_uri_queries(uri, atc_modal)
    # if there are actually queries, we use the URI Module to convert queries to hash,
    # we add our custom queries and we encode the hash to query again
    if uri.query
      hash_uri = Hash[URI.decode_www_form(uri.query)]
      hash_uri['chosen_product'] = @product_variation.product.name
      atc_modal ? hash_uri['atc_modal'] = true : hash_uri.delete('atc_modal')
      URI.encode_www_form(hash_uri)
    else
      # if there is no queries, we just add the queries we need
      "chosen_product=#{@product_variation.product.name}#{'&atc_modal=true' if atc_modal}"
    end
  end

  # def line_item_params
  #   params.require(:line_item).permit(:quantity, :product_variation_id, :cart_id)
  # end

  def error_json_response
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
