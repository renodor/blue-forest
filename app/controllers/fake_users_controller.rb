class FakeUsersController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @fake_user = FakeUser.new
    @address = Address.new
    @breadcrumb_contact_class = 'active'
    @breadcrumb_shipping_class = 'pending'
    @breadcrumb_review_class = @breadcrumb_confirm_class = 'pending hide-under-576'
  end

  def create
    @fake_user = FakeUser.new(fake_user_params)
    if @fake_user.save
      redirect_to new_fake_user_address_path(@fake_user)
    else
      render :new
    end
  end

  def edit
    # DRY
    @breadcrumb_contact_class = 'active'
    @breadcrumb_review_class = @breadcrumb_confirm_class = 'pending hide-under-576'

    @fake_user = FakeUser.find(params[:id])
  end

  def update
    @fake_user = FakeUser.find(params[:id])
    if @fake_user.update(fake_user_params)
      redirect_to new_fake_user_order_path(@fake_user)
    else
      render :edit
    end
  end

  private

  def fake_user_params
    params.require(:fake_user).permit(:first_name, :last_name, :email, :address, :phone)
  end
end
