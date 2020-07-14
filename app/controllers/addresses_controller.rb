class AddressesController < ApplicationController
  before_action :find_user
  before_action :set_breadcrumb_classes, only: %i[new edit]
  skip_before_action :authenticate_user!, only: %i[new create edit update]

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    user_signed_in? ? @address.user = @user : @address.fake_user = @user

    if @address.save
      redirect_to_correct_path
    else
      set_breadcrumb_classes
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    user_signed_in? ? @address.user = @user : @address.fake_user = @user
    if @address.update(address_params)
      redirect_to_correct_path
    else
      render :edit
    end
  end

  private

  def find_user
    @user = user_signed_in? ? current_user : FakeUser.find(params[:fake_user_id])
  end

  # define what part of order breadcrumb is active/pending or hidden en mobile
  # (depending on what step we are on the order funnel)
  # those are css classes
  def set_breadcrumb_classes
    return if params[:from_dashboard]

    @breadcrumb_contact_class = 'hide-under-576'
    @breadcrumb_shipping_class = 'active'
    @breadcrumb_review_class = 'pending'
    @breadcrumb_confirm_class = 'pending hide-under-576'
  end

  def redirect_to_correct_path
    if user_signed_in?
      # if from_dashboard params is present, the user is creating its address from its dashboard
      # in that case we need to redirect him to his dashbaord after create
      if params[:from_dashboard]
        redirect_to dashboards_path
      else
        redirect_to new_user_order_path(@user)
      end
    else
      redirect_to new_fake_user_order_path(@user)
    end
  end

  def address_params
    params.require(:address).permit(:street, :flat_number, :district, :area,
                                    :detail, :city, :latitude, :longitude)
  end
end
