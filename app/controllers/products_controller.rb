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

    # build an array to store all colors
    @colors = []

    # build an hash to store all sizes, their count and their associated colors
    # (in order to know what sizes are repeated accross colors)
    @sizes = {}

    # then iterate over all product variations and do 3 things:
    # 1. add its color to the @colors array
    # 2. add its size, its size count and its associated colors to the @sizes hash
    # 3. add all its photos in the @photo array
    @product_variations.each do |variation|
      @colors << variation.color

      if @sizes[variation.size]
        @sizes[variation.size][:count] += 1
        @sizes[variation.size][:colors] << variation.color

      # the @sizes hash has 2 elements:
      # 1. the size count (to see if a size is repeated or not)
      # 2. the associated colors of this size (to see for what colors the size is repeated)
      else
        @sizes[variation.size] = {
          count: 1,
          colors: [variation.color]
        }
      end
      variation.photos.each do |photo|
        @photos << photo
      end
    end

    # remove duplicates from colors
    @colors.uniq!
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

