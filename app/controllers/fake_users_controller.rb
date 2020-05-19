class FakeUsersController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @fake_user = FakeUser.new
    @address = Address.new
    @breadcrumb_contact_class = 'active'
    @breadcrumb_shipping_class = @breadcrumb_review_class = @breadcrumb_confirm_class = 'pending'
  end

  def create
    @fake_user = FakeUser.new(fake_user_params)
    if @fake_user.save
      redirect_to new_fake_user_address_path(@fake_user)
    else
      render :new
    end
  end

  private

  def fake_user_params
    params.require(:fake_user).permit(:first_name, :last_name, :email, :address, :phone)
  end
end
