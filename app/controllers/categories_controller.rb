class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @category = Category.find(params[:id])
    @products = @category.products.published.ordered
    @product_favorites = current_user.product_favorites if user_signed_in?
  end
end
