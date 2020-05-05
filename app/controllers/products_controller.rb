class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @products = Product.all
  end

  def show
    # get all product pre-loading its product variations
    @product = Product.includes(:product_variations).find(params[:id])

    # build a hash with the relevant product variations filtered by colors and sizes
    # @product_variations = {colors: [], sizes: []}
    # @product.product_variations.each do |variation|
    #   @product_variations[:colors] << variation if variation.name == "color"
    #   @product_variations[:sizes] << variation if variation.name == "size"
    # end
  end
end

