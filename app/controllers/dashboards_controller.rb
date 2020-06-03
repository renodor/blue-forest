class DashboardsController < ApplicationController
  def dashboard
    @address = current_user.addresses.first
    @orders = current_user.orders.reverse
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

  # DRY
  # to simplify
  def product_creation_create
    @product = Product.new(name: params[:name], short_description: params[:short_description], long_description: params[:long_description], published: params[:published])
    @product.save!

    params[:color_variations].each do |color_variation|

      next if params[:product_type] == 'without_colors' && color_variation[:color] != 'unique'
      next if params[:product_type] == 'with_colors' && color_variation[:color] == 'unique'

      color_variation[:size_variations].each do |size_variation|
        product_variation = ProductVariation.new(product_id: @product.id, size: size_variation[:size], price: size_variation[:price], discount_price: size_variation[:discount_price], quantity: size_variation[:quantity])
        product_variation.color = color_variation[:color] if color_variation[:color] != 'unique'
        product_variation.save!
      end

      photos = []
      color_variation[:photos].each do |variation_photo|
        photos << {io: variation_photo, filename: @product.name, content_type: variation_photo.content_type}
      end

      @product_photo = ProductPhoto.new
      @product_photo.photos.attach(photos)
      @product_photo.color = color_variation[:color] if color_variation[:color] != 'unique'
      @product_photo.main = true
      @product_photo.product = @product
      @product_photo.save!
    end

    flash[:notice] = "Product Created"
    redirect_to product_creation_path
  end

  private

end
