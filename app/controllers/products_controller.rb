class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @products = Product.all
  end

  def product_grid
    @products = Product.all
  end
end
