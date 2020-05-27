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

    @colors = Hash.new(0)
    @sizes = Hash.new(0)


    # then iterate over all product variations and do 2 things:
    # 2. put all picturs in the @photo array
    @product_variations.each do |variation|
      @colors[variation.color] += 1
      @sizes[variation.size] += 1
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

