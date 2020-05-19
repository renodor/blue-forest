class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  layout "pdp", only: [:show]

  def index
    @products = Product.includes(:product_variations).where(published: true)
  end

  def show
    # get all product pre-loading its product variations
    @product = Product.includes(:product_variations).find(params[:id])

    @first_published_variation = @product.product_variations.find do |variation|
      variation.published && variation.quantity > 0
    end
  end

  def search
    sql_query = " \
      products.name ILIKE :query AND products.published = true \
      OR products.description ILIKE :query AND products.published = true \
    "
    @products = Product.includes(:product_variations).where(sql_query, query: "%#{params[:query]}%")
  end
end

