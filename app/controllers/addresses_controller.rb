class AddressesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    if user_signed_in?
      @user = current_user
    else
      @user = FakeUser.find(params[:fake_user_id])
    end
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    if user_signed_in?
      @user = current_user
      @address.user = @user
      redirect_to new_user_order_path(@user) if @address.save
      return
    else
      @user = FakeUser.find(params[:fake_user_id])
      @address.fake_user = @user
      redirect_to new_fake_user_order_path(@user) if @address.save
      return
    end

    # if non of the address can be saved, then no redirect, then render new again for form validation
    render :new
  end

  private

  def address_params
    params.require(:address).permit(:street, :flat_number, :district, :detail, :city, :latitude, :longitude)
  end
end
