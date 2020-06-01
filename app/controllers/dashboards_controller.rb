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

    params[:size_variations].each do |size_variation|
      product_variation = ProductVariation.create(product_id: @product.id, size: size_variation[:size], price: size_variation[:price], discount_price: size_variation[:discount_price], quantity: size_variation[:quantity])
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
  end

  private

  def upload_file_to_cloudinary

    raise
  #   Cloudinary::Uploader.upload("dog.mp4",
  # :folder => "my_folder/my_sub_folder/", :public_id => "my_dog", :overwrite => true,
  # :notification_url => "https://mysite.example.com/notify_endpoint", :resource_type => "video")
    # uploaded_file = params['variation-photo']
    # File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
    #   file.write(uploaded_file.read)
    # end
  end

end
