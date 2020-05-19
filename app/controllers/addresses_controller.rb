class AddressesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    if user_signed_in?
      @user = current_user
    else
      @user = FakeUser.find(params[:fake_user_id])

      # define what part of order breadcrumb is active/pending or hidden en mobile
      # (depending on what step we are on the order funnel)
      # those are css classes
      @breadcrumb_contact_class = 'hide-under-576'
      @breadcrumb_shipping_class = 'active'
      @breadcrumb_review_class = 'pending'
      @breadcrumb_confirm_class = 'pending hide-under-576'
    end
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
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

  private

  def address_params
    params.require(:address).permit(:street, :flat_number, :district, :detail, :city, :latitude, :longitude)
  end
end
