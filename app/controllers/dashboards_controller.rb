class DashboardsController < ApplicationController
  def dashboard
    @address = current_user.addresses.first
    @orders = current_user.orders.order(created_at: :desc)
  end

  def product_creation_new
    if !current_user.admin
      flash[:alert] = 'Need admin rights to create products'
      redirect_to root_path
      return
    end

    @product = Product.new
    @product_variation = ProductVariation.new
    @photo = ProductPhoto.new

    @colors = []
    ProductVariation::COLORS.each do |key, value|
      @colors << "<option value='#{key}'>#{key}</option>"
    end
  end

  def product_creation_create
    if form_validation[:valid?]
      # create a new product with product creation form params
      @product = Product.new(name: params[:name], short_description: params[:short_description], long_description: params[:long_description])
      params[:published] ? @product.published = true : @product.published = false
      @product.save!

      # iterate over all color variations params
      params[:color_variations].each do |color_variation|
        # both product 'without colors' and 'with colors' options are present on the form DOM
        # it means even if we create a product without colors, the form will also have (empty) params for a product variation with colors
        # (and the contrary as well : if we create a product with colors, the form will also have (empty) params for a product variation without colors)
        # but product variation without color color value is 'unique' by default'
        # So if product type is 'without colors', it means we can skip product variations that dont have the color value 'unique'
        # and if product type is 'with colors', it means we can skip product variations that has the color value 'unique'
        next if params[:product_type] == 'without_colors' && color_variation[:color] != 'unique'
        next if params[:product_type] == 'with_colors' && color_variation[:color] == 'unique'

        # iterate over size variations params
        color_variation[:size_variations].each do |size_variation|
          # for each size variation, create a new Product Variation instance with size variation params
          product_variation = ProductVariation.new(product_id: @product.id, size: size_variation[:size], price: size_variation[:price], discount_price: size_variation[:discount_price], quantity: size_variation[:quantity])
          # product variation color need to stay empty if there is no colors
          # so put the color variation params unless the color value is 'unique'
          product_variation.color = color_variation[:color] unless color_variation[:color] == 'unique'
          product_variation.save!
        end

        # initialize a photo array
        photos = []

        # create a new instance of product photos and attach it to the product
        @product_photo = ProductPhoto.new
        @product_photo.product = @product

        # iterate over photos params
        color_variation[:photos].each do |variation_photo|
          if variation_photo[:main]
            # if this is the main photo, put the photo at the beginning of the photos array
            # and set this product photo as the main one
            photos.unshift({io: variation_photo[:photo], filename: @product.name, content_type: variation_photo[:photo].content_type})
            @product_photo.main = true
          else
            # otherwise just add photo to the photos array
            photos << {io: variation_photo[:photo], filename: @product.name, content_type: variation_photo[:photo].content_type}
          end
        end

        # attach all photos to this product photo instance
        @product_photo.photos.attach(photos)
        # product photo color need to stay empty if there is no colors
        # so put the color variation params unless the color value is 'unique'
        @product_photo.color = color_variation[:color] unless color_variation[:color] == 'unique'
        @product_photo.save!
      end
      flash[:notice] = "Product Created"
      redirect_to product_creation_path
    else
      flash[:alert] = form_validation[:error_message]
      render :product_creation_new
    end
  end

  def form_validation
    result = { valid?: true, error_message: '' }

    if params[:name].empty?
      result[:valid?] = false
      result[:error_message] = 'Product name is empty'
    end

    return result
  end

end
