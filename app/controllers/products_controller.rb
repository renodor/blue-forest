class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @products = Product.includes(:product_variations).where(published: true)

  end

  def show
    # get all product pre-loading its product variations
    @product = Product.includes(:product_variations).find(params[:id])
  end

  def search
    sql_query = " \
      products.name ILIKE :query AND products.published = true \
      OR products.description ILIKE :query AND products.published = true \
    "
    @products = Product.includes(:product_variations).where(sql_query, query: "%#{params[:query]}%")
  end
end

