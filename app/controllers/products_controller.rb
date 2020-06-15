class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :search]
  layout 'pdp', only: [:show]
  layout 'homepage', only: [:index]


  def index
    @products = Product.includes(:product_variations, :product_photos).where(published: true).order(updated_at: :desc)
  end

  def show
    # get the product pre-loading its product variations and product photos
    @product = Product.includes(:product_variations, :product_photos).find(params[:id])

    # filter product variations to only take the ones published and with stock quantity
    unsorted_product_variations = @product.product_variations.order(price: :asc).filter do |variation|
      if variation.published && variation.quantity > 0
        variation
      end
    end

    # then order product variation by sizes
    @product_variations = sort_by_sizes(unsorted_product_variations)

    # build an hash to store all colors (without repetition)
    # and identify the main color
    @colors = {}

    # build an hash to store all sizes, their count and their associated colors
    # (in order to know what sizes are repeated accross colors)
    @sizes = {}

    # build an array to store all product photos
    @product_photos = []

    # then iterate over all product variations and do 3 things:
    # 1. add its color to the @colors hash
    # 2. add its photos to the @product_photos hrray
    # 3. add its size, its size count and its associated colors to the @sizes hash
    @product_variations.each do |variation|
      # only add color and photos if the variation has a specific color (that we didn't came accross before)
      # indeed different product variations can have the same color
      # but a color need to be added only once in the color hash
      # and all photos of the same colors are in the same product_photo instance
      # so photos need to be added only once by color in the product_photos array as well
      if variation.color && !@colors[variation.color]
        # find the product photo corresponding to this color, and add it to the product_photos array as well
        product_photo = @product.product_photos.find_by(color: variation.color)
        @product_photos << product_photo

        # if this photo/color is the main one, flag it as 'main' and put it at the beginning of th @colors hash
        # if we find a (normal) new color, add it to the hash, and set its value to true
        product_photo.main ? @colors[variation.color] = 'main' : @colors[variation.color] = true
      end


      # the @sizes hash has 2 elements:
      # 1. the size count (to see if a size is repeated or not)
      # 2. an array with the associated colors of this size (to see for what colors the size is repeated)
      if @sizes[variation.size]
        @sizes[variation.size][:count] += 1
        @sizes[variation.size][:colors] << variation.color
      else
        @sizes[variation.size] = {
          count: 1,
          colors: [variation.color]
        }
      end
    end

    # if this is a product without color variations, at this point @product_photos array is still empty
    # (because we only added photos for which we found a corresponding color)
    # so if its the case, it means the product doesn't have color variations, so it only has 1 product_photo instance
    # (with all photos of this product in it)
    # in that case, just add it to the @product_photos array
    if @product_photos.empty?
      @product_photos << @product.product_photos.first
    end

    # if product is not published, redirect to hp unless current user is an admin
    if !@product.published
      redirect_to root_path unless current_user && current_user.admin
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

  private

  # helper method to sort product variations by sizes
  def sort_by_sizes(variations)
    variations.sort do |a, b|
      # if sizes have a number (like 'Pack10'), just sort by number
      if a.size.match?(/.*\d.*/)
        a.size.gsub(/\D*/, '').to_i <=> b.size.gsub(/\D*/, '').to_i

      # if not, we assume that product variation has 'clothes sizes' (like L, M, XL etc...)
      # so we need to use our clothes_sizes_order method to sort product variations correctly
      else
        clothes_sizes_order(a.size) <=> clothes_sizes_order(b.size)
      end
    end
  end

  def clothes_sizes_order(size)
    return 0 if size == 'XS'
    return 1 if size == 'S'
    return 2 if size == 'M'
    return 3 if size == 'L'
    return 4 if size == 'XL'
    return 5 if size == 'XXL'
  end
end

