class ProductFavoritesController < ApplicationController
  def create
    favorite = ProductFavorite.new
    favorite.user = current_user
    favorite.product = Product.find(params[:product_id])
    favorite.save
  end

  def destroy
    ProductFavorite.find(params[:id]).destroy
    redirect_to dashboards_path(anchor: 'favorites')
  end
end