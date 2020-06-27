class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @category = Category.find(params[:id])

    @products = @category.products.order(order: :asc)
  end
end
