class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show search]

  def index
    @products = Product.includes(:product_variations, product_photos: [photos_attachments: :blob])
                       .published
                       .ordered

    render layout: 'homepage'
  end

  def show
    # get the product pre-loading its product variations and product photos
    @product = Product.with_published_variations
                      .find(params[:id])

    # then filter unpublished product variations and order product variation by sizes
    @product_variations = sort_by_sizes(@product.product_variations)
    build_product_variations_variables

    # for product without color variations, at this point @product_photos array is still empty
    # (because we only added photos for which we found a corresponding color)
    # so if the product doesn't have color variations, it only has 1 product_photo instance
    # (with all photos of this product in it)
    # in that case, just add it to the @product_photos array
    @product_photos << @product.product_photos.first if @product_photos.empty?

    # if product is not published, redirect to hp unless current user is an admin
    redirect_to root_path and return unless current_user&.admin || @product.published

    render layout: 'pdp'
  end

  def search
    sql_query = " \
      products.name ILIKE :query AND products.published = true \
      OR products.short_description ILIKE :query AND products.published = true \
      OR products.long_description ILIKE :query AND products.published = true \
    "
    @products = Product.with_published_variations
                       .published
                       .where(sql_query, query: "%#{params[:query]}%")
                       .ordered
  end

  private

  # helper method to sort product variations by sizes
  def sort_by_sizes(variations)
    clothes_sizes_regex = /XS|S|M|L|XL|XXL/
    variations.sort do |a, b|
      a = a.size
      b = b.size

      # If size has 'clothes sizes' (like L, M, XL etc...)
      # we use our clothes_sizes_order method to sort product variations correctly
      if a.match?(clothes_sizes_regex) && b.match?(clothes_sizes_regex)
        clothes_sizes_order(a) <=> clothes_sizes_order(b)
      # otherwise use the 'normal' size order method
      else
        sizes_order(a) <=> sizes_order(b)
      end
    end
  end

  # helper method to define the order of 'clothes sizes'
  def clothes_sizes_order(size)
    return 1 if size == 'XS'
    return 2 if size == 'S'
    return 3 if size == 'M'
    return 4 if size == 'L'
    return 5 if size == 'XL'
    return 6 if size == 'XXL'
  end

  # helper method to define order of sizes :
  # - if size is 'unit', it should go first
  # - if size has a number (like 'Pack10', 'Pack15'), order by number
  # - otherwise we have no clue how to order, so don't order it
  def sizes_order(size)
    return -1 if size.match?(/unit/i)

    if size.match?(/.*\d.*/)
      size.gsub(/\D*/, '').to_i
    else
      0
    end
  end

  # then iterate over all product variations and do 3 things:
  # 1. add its color to the @colors hash
  # 2. add its photos to the @product_photos array
  # 3. add its size, its size count and its associated colors to the @sizes hash
  def build_product_variations_variables
    # build an hash to store all colors (without repetition)
    # build an hash to store all sizes, their count and their associated colors
    # (in order to know what sizes are repeated accross colors)
    @colors, @sizes, @product_photos = {}, {}, []

    # build an array to store all product photos
    @product_photos = []
    @product_variations.each_with_index do |variation, index|
      build_product_photos_variable(variation, index)
      # the @sizes hash has 2 elements:
      # 1. the size count (to see if a size is repeated or not)
      # 2. an array with the colors of this size (to know for what colors the size is repeated)
      if @sizes[variation.size]
        @sizes[variation.size][:colors] << variation.color
      else
        @sizes[variation.size] = { colors: [variation.color] }
      end
    end
  end

  def build_product_photos_variable(product_variation, index)
    # only add color and photos if the variation has a specific color (that we didn't see before)
    # indeed different product variations can have the same color
    # but a color need to be added only once in the color hash
    # and all photos of the same colors are in the same product_photo instance
    # so photos need to be added only once by color in the product_photos array as well
    return unless product_variation.color && !@colors[product_variation.color]

    # find the product photo corresponding to this color, and add it to the product_photos array
    product_photo = @product.product_photos.find_by(color: product_variation.color)
    @product_photos << product_photo

    # if this photo/color is the main one, put it in the @colors hash with the value 'main',
    # otherwise just put it in the @colors hash with the value true
    if product_photo # (prevent from crashing if for some reason it has no photos)
      @colors[product_variation.color] = product_photo.main ? 'main' : true
    else # (if there are no photos, put the first color as the main one by default)
      @colors[product_variation.color] = index.zero? ? 'main' : true
    end
  end
end
