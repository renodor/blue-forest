class DashboardsController < ApplicationController
  def dashboard
    @address = current_user.addresses.first
    @orders = current_user.orders.order(created_at: :desc)
    @favorites = current_user.product_favorites.order(created_at: :desc)
  end

  def product_creation_new
    unless current_user.admin
      flash[:alert] = 'Need admin rights to create products'
      redirect_to root_path
      return
    end

    @product = Product.new
    @product_variation = ProductVariation.new
    @photo = ProductPhoto.new

    @colors = ProductVariation::COLORS.map { |key, _| "<option value='#{key}'>#{key}</option>" }
  end

  def product_creation_create
    create_product
    create_product_variations
    flash[:notice] = 'Product Created'
    redirect_to product_creation_path
  end

  private

  # def form_validation
  #   result = { valid?: true, error_message: '' }

  #   if params[:name].empty?
  #     result[:valid?] = false
  #     result[:error_message] = 'Product name is empty'
  #   elsif params[:product_type] == 'without_colors'
  #     params[:color_variations].each do |color_variation|
  #       next if color_variation[:color] != 'unique'

  #       color_variation[:size_variations].each do |size_variation|
  #         if size_variation[:size].empty?
  #           result[:valid?] = false
  #           result[:error_message] = 'Size is empty'
  #         elsif size_variation[:price].empty?
  #           result[:valid?] = false
  #           result[:error_message] = 'Price is empty'
  #         elsif size_variation[:quantity].empty?
  #           result[:valid?] = false
  #           result[:error_message] = 'Price is empty'
  #         end
  #       end
  #     end
  #   end
  #   result
  # end

  def create_product
    # create a new product with product creation form params
    @product = Product.new(
      name: params[:name],
      short_description: params[:short_description],
      long_description: params[:long_description]
    )
    @product.published = params[:published] ? true : false
    @product.save!
  end

  def create_product_variations
    # iterate over all color variations params
    params[:color_variations].each do |color_variation|
      # both product 'without colors' and 'with colors' options are present on the form DOM
      # So even for a product without color, the form will have (empty) color variations params
      # (and the contrary as well)
      # but for product variation without color, color value is 'unique' by default'
      # So for product 'without colors', we can skip product variations without the color 'unique'
      # And for product 'with colors', we can skip product variations with the color 'unique'
      next if params[:product_type] == 'without_colors' && color_variation[:color] != 'unique'
      next if params[:product_type] == 'with_colors' && color_variation[:color] == 'unique'

      # iterate over size variations params
      create_size_variations(color_variation)
      create_product_photos(color_variation)
    end
  end

  def create_size_variations(color_variation)
    color_variation[:size_variations].each do |size_variation|
      # for each size variation, create a new Product Variation with size variation params
      product_variation = ProductVariation.new(
        product_id: @product.id, size: size_variation[:size].strip,
        price: size_variation[:price].strip,
        discount_price: size_variation[:discount_price].strip,
        quantity: size_variation[:quantity].strip
      )

      # product variation color need to stay empty if there is no colors
      # so put the color variation params unless the color value is 'unique'
      product_variation.color = color_variation[:color] unless color_variation[:color] == 'unique'
      product_variation.save!
    end
  end

  def create_product_photos(color_variation)
    # create a new instance of product photos and attach it to the product
    @product_photo = ProductPhoto.new
    @product_photo.product = @product

    create_photos_array(color_variation)
    return if @photos.empty?

    # attach all photos to this product photo instance
    @product_photo.photos.attach(@photos)
    # product photo color need to stay empty if there is no colors
    # so put the color name unless the color value is 'unique'
    @product_photo.color = color_variation[:color] unless color_variation[:color] == 'unique'
    @product_photo.save!
  end

  def create_photos_array(color_variation)
    # initialize a photo array
    @photos = []

    # iterate over photos params
    color_variation[:photos].each do |variation_photo|
      next unless variation_photo[:photo]

      if variation_photo[:main]
        # if this is the main photo, put the photo at the beginning of the photos array
        # and set this product photo as the main one
        # (so that, the main photo will always be the first one of the product photos array)
        @photos.unshift(photo_hash(variation_photo))
        @product_photo.main = true
      else
        # otherwise just add photo to the photos array
        @photos << photo_hash(variation_photo)
      end
    end
  end

  def photo_hash(variation_photo)
    { io: variation_photo[:photo],
      filename: @product.name,
      content_type: variation_photo[:photo].content_type }
  end
end
