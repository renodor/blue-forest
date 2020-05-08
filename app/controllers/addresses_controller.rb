class AddressesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @fake_user = FakeUser.find(params[:fake_user_id])
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @fake_user = FakeUser.find(params[:fake_user_id])
    @address.fake_user = @fake_user
    if @address.save
      redirect_to new_order_path
    else
      render :new
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :flat_number, :district, :detail, :city, :latitude, :longitude)
  end
end
