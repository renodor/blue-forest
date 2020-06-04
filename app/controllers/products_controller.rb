class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :search]
  layout 'pdp', only: [:show]
  layout 'homepage', only: [:index]


  def index
    @products = Product.includes(:product_variations, :product_photos).where(published: true)
  end

  def show
    # get all product pre-loading its product variations and product photos
    @product = Product.includes(:product_variations, :product_photos).find(params[:id])

    # filter product variations to only take the ones published and with stock quantity
    @product_variations = @product.product_variations.filter do |variation|
      if variation.published && variation.quantity > 0
        variation
      end
    end

    # build an array to store all colors
    @colors = {}

    # build an hash to store all sizes, their count and their associated colors
    # (in order to know what sizes are repeated accross colors)
    @sizes = {}

    @product_photos = []

    # then iterate over all product variations and do 2 things:
    # 1. add its color to the @colors array
    # 2. add its size, its size count and its associated colors to the @sizes hash
    @product_variations.each do |variation|
      if variation.color && !@colors[variation.color]
        @colors[variation.color] = true
        product_photo = @product.product_photos.find_by(color: variation.color)
        @product_photos << product_photo
        @colors[variation.color] = 'main' if product_photo.main
      end

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
    end

    if @product_photos.empty?
      @product_photos << @product.product_photos.first
    end

    # # remove color duplicates
    # # OPTMIZE > We could use a hash for @colors in order to count colors and not put duplicate at the very beginning.
    # # which would allow to delete this .uniq! step
    # @colors.uniq!

    # # if product has several product_photos instances, it means it has several color variations
    # # in that case we need to build a @product_photo array that has the product_photo instances of all published product_variations
    # # for that we use the @color array, because we already filtered it to only take the colors of published product variations


    # if @product.product_photos.count > 1
    #   @product_photos = @product.product_photos.filter do |product_photo|
    #     @colors.include?(product_photo.color)
    #   end
    # else
    #   # if product only has 1 product_photos instance, just store this one
    #   @product_photos << @product.product_photos.first
    # end
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

