class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :search]
  layout 'pdp', only: [:show]
  layout 'homepage', only: [:index]


  def index
    @products = Product.includes(:product_variations).where(published: true)
  end

  def show
    # get all product pre-loading its product variations
    @product = Product.includes(:product_variations).find(params[:id])

    # filter product variations to only take the ones published and with stock quantity
    @product_variations = @product.product_variations.filter do |variation|
      if variation.published && variation.quantity > 0
        variation
      end
    end

    # build an array to store all the photos
    @photos = []
    # put first the main product photo
    @photos << @product.main_photo

    # build an hash to group variation by colors
    @variations_by_color = {}

    # then iterate over all product variations and do 2 things:
    # 1. group them by colors in the @variations_by_color hash
    # 2. put all picturs in the @photo array
    @product_variations.each do |variation|
      if @variations_by_color[variation.color]
        @variations_by_color[variation.color] << variation
      else
        @variations_by_color[variation.color] = [variation]
      end
      variation.photos.each do |photo|
        @photos << photo
      end
    end
  end

  def search
    sql_query = " \
      products.name ILIKE :query AND products.published = true \
      OR products.short_description ILIKE :query AND products.published = true \
      OR products.long_description ILIKE :query AND products.published = true \
    "
    @products = Product.includes(:product_variations).where(sql_query, query: "%#{params[:query]}%")
  end
end

