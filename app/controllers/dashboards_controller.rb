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
  end

  def product_creation_create
    @product = Product.new(name: params[:name], short_description: params[:short_description], long_description: params[:long_description], published: params[:published])
    @product.save

    if params[:product_type] == 'without_colors'
      params[:size_variations].each do |size_variation|
        ProductVariation.create(product_id: @product.id, size: size_variation[:size], price: size_variation[:price], discount_price: size_variation[:discount_price], quantity: size_variation[:quantity])
      end

      photos = []
      params[:variation_photos].each do |variation_photo|
        photos << {io: variation_photo[:photo], filename: @product.name, content_type: variation_photo[:photo].content_type}
      end

      @product_photo = ProductPhoto.new

      @product_photo.photos.attach(photos)
      @product_photo.main = true
      @product_photo.product = @product
      @product_photo.save
    else
      params[:color_variations].each do |color_variation|
        color_variation[:size_variations].each do |size_variation|
          ProductVariation.create!(product_id: @product.id, color: color_variation[:color], size: size_variation[:size],price: size_variation[:price], discount_price: size_variation[:discount_price], quantity: size_variation[:quantity])
        end

        photos = []
        color_variation[:photos].each do |variation_photo|
          photos << {io: variation_photo, filename: @product.name, content_type: variation_photo.content_type}
        end

        @product_photo = ProductPhoto.new
        @product_photo.color = color_variation[:color]
        @product_photo.photos.attach(photos)
        @product_photo.main = true
        @product_photo.product = @product
        @product_photo.save
      end
    end
  end

  private

end
