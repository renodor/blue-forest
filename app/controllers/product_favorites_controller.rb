class ProductFavoritesController < ApplicationController
  def create
    favorite = ProductFavorite.new
    favorite.user = current_user
    favorite.product = Product.find(params[:product_id])
    favorite.save

    respond_to do |format|
      format.json { render json: { product_favorite_id: favorite.id } }
    end
  end

  def destroy
    ProductFavorite.find(params[:id]).destroy
  end
end
