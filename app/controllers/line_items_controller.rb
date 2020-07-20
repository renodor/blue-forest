class LineItemsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_line_item, only: %i[add_quantity reduce_quantity destroy]

  def create
    # Find associated product variation
    @product_variation = ProductVariation.find(params[:variation_id])

    # Check if there is enough stock available for the quantity the user wants to buy
    # if not, redirect and return
    redirect_to_correct_path and return unless @product_variation.quantity >= params[:quantity].to_i

    # try to find a line item corresponding to the chosen product variation
    # if true, try to add quantity, if false redirect and return
    # otherwise create a new line item for the chosen product variation
    if find_line_item
      redirect_to_correct_path and return unless add_quantity
    else
      create_new_line_item
    end
    # if we arrive here without redirecting and return,
    # it means line item has been correctly created
    # so we can redirect and trigger atc modal
    redirect_to_correct_path(true)
  end

  def add_quantity
    # check if there is enough product variation stock regarding the quantity user wants to add
    # and the quantity already present for this line item in user cart
    if (@line_item.quantity + params[:quantity].to_i) <= @line_item.product_variation.quantity
      @line_item.quantity += params[:quantity].to_i
      @line_item.save
      # this method can be triggered by https or ajax request
      # so we use an external method to trigger the correct response
      trigger_correct_response_after_adding_quantity(true)
    else
      trigger_correct_response_after_adding_quantity(false)
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

  def create_new_line_item
    @line_item = LineItem.new
    @line_item.cart = @current_cart
    @line_item.product_variation = @product_variation
    @line_item.quantity = params[:quantity].to_i
    @line_item.save
  end

  def trigger_correct_response_after_adding_quantity(can_add_quantity)
    if request.xhr?
      can_add_quantity ? cart_info_json_response : error_json_response
    else
      can_add_quantity ? true : false
    end
  end

  def find_line_item
    # the find_line_item method is triggered in the add_quantity method
    # but the add_quantity method can be triggered also after the find_line_item method
    # if its the case @line_item already exists, so we can skip everything and return
    return if @line_item

    # check if the chosen product variation already exists in user cart
    if @product_variation && @current_cart.product_variations.include?(@product_variation)
      # if yes, find the corresponding line_item
      @line_item = @current_cart.line_items.find_by(product_variation_id: @product_variation.id)
    elsif params[:id]
      # if not check if we have a params to find the line_item
      @line_item = LineItem.find(params[:id])
    else
      # if not return fals to indicate we can't find the corresponding line_item
      false
    end
  end

  # method that redirect to the correct path after creating (or trying to create) a new line item
  # if atc_modal param is present it means line item was successfully created,
  # and it will trigger the atc_modal
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
      # finally reconstruct the complete path and redirect to it
      redirect_to "#{uri.path}?#{queries}"
    else
      # if product was added from a pdp, just trigger atc_modal and redirect to pdp
      redirect_to product_path(@product_variation.product, atc_modal: atc_modal)
    end
  end

  # method to construct uri queries without losing existing ones and returns it
  def construct_uri_queries(uri, atc_modal)
    # if there are actually queries, we use the URI Module to convert queries to hash,
    # we add our custom queries and we encode the hash to query again
    if uri.query
      hash_uri = Hash[URI.decode_www_form(uri.query)]
      hash_uri['chosen_product'] = @product_variation.product.name
      atc_modal ? hash_uri['atc_modal'] = true : hash_uri.delete('atc_modal')
      URI.encode_www_form(hash_uri)
    else
      # if there are no queries, we just add the queries we need
      "chosen_product=#{@product_variation.product.name}#{'&atc_modal=true' if atc_modal}"
    end
  end

  # json response if we can't add quantity from this line item
  def error_json_response
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
        render json: { can_change_quantity: true, current_cart: @current_cart,
                       total_items: @current_cart.total_items.to_i,
                       sub_total: @current_cart.sub_total, shipping: @current_cart.shipping.to_f,
                       itbms: @current_cart.itbms.to_f, total: @current_cart.total.to_f }
      end
    end
  end
end
