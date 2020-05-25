class AddressesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def new
    # DRY
    if user_signed_in?
      @user = current_user
    else
      @user = FakeUser.find(params[:fake_user_id])

    end
    # define what part of order breadcrumb is active/pending or hidden en mobile
    # (depending on what step we are on the order funnel)
    # those are css classes
    @breadcrumb_contact_class = 'hide-under-576'
    @breadcrumb_shipping_class = 'active'
    @breadcrumb_review_class = 'pending'
    @breadcrumb_confirm_class = 'pending hide-under-576'

    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    # DRY
    if user_signed_in?
      @user = current_user
      @address.user = @user
      user_type = 'user'
    else
      @user = FakeUser.find(params[:fake_user_id])
      @address.fake_user = @user
    end

    if @address.save
      if user_type == 'user'
        redirect_to new_user_order_path(@user)
      else
        redirect_to new_fake_user_order_path(@user)
      end
    else
      # if none of the address can be saved, then no redirect, then render new again for form validation

      @breadcrumb_contact_class = 'hide-under-576'
      @breadcrumb_shipping_class = 'active'
      @breadcrumb_review_class = 'pending'
      @breadcrumb_confirm_class = 'pending hide-under-576'
      render :new
    end
  end

  def edit
    # DRY
    @breadcrumb_contact_class = 'hide-under-576'
    @breadcrumb_shipping_class = 'active'
    @breadcrumb_review_class = 'pending'
    @breadcrumb_confirm_class = 'pending hide-under-576'

    # DRY
    if user_signed_in?
      @user = current_user
    else
      @user = FakeUser.find(params[:fake_user_id])
    end
    @address = Address.find(params[:id])
  end

  def update
    # DRY
    if user_signed_in?
      @user = current_user
      user_type = 'user'
    else
      @user = FakeUser.find(params[:fake_user_id])
    end

    @address = Address.find(params[:id])
    # DRY & ugly...
    if user_type == 'user'
      @address.user = @user
      if @address.update(address_params)
        redirect_to new_user_order_path(@user)
      else
        render :edit
      end
    else
      @address.fake_user = @user
      if @address.update(address_params)
        redirect_to new_fake_user_order_path(@user)
      else
        render :edit
      end
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :flat_number, :district, :detail, :city, :latitude, :longitude)
  end
end
