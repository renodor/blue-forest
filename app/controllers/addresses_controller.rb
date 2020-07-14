class AddressesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create edit update]

  def new
    find_user
    set_breadcrumb_classes
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    find_user
    user_signed_in? ? @address.user = @user : @address.fake_user = @user

    if @address.save
      redirect_to_correct_path_after_address_creation
    else

      set_breadcrumb_classes

      # if none of the address can be saved, then no redirect and render new again
      render :new
    end
  end

  def redirect_to_correct_path_after_address_creation
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

  def edit
    set_breadcrumb_classes
    find_user
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    find_user
    user_signed_in? ? @address.user = @user : @address.fake_user = @user
    if @address.update(address_params)
      redirect_to_correct_path_after_address_update
    else
      render :edit
    end
  end

  # if user wants to modify its address, there are 3 conditions possibles:
  # Option1: It is a registered user, who wants to modify its address while ordering
  # Option2: It is a registered user, who wants to modify its address from its dashboard
  # Option3: It is a non-registered user (fake user), who wants to modify its address while ordering
  def redirect_to_correct_path_after_address_update
    if user_signed_in?
      if params['order_edit']
        # Option1
        redirect_to new_user_order_path(@user)
      else
        # Option2
        redirect_to dashboards_path
      end
    else
      # Option3
      redirect_to new_fake_user_order_path(@user)
    end
  end

  private

  # define what part of order breadcrumb is active/pending or hidden en mobile
  # (depending on what step we are on the order funnel)
  # those are css classes
  def set_breadcrumb_classes
    @breadcrumb_contact_class = 'hide-under-576'
    @breadcrumb_shipping_class = 'active'
    @breadcrumb_review_class = 'pending'
    @breadcrumb_confirm_class = 'pending hide-under-576'
  end

  def find_user
    @user = user_signed_in? ? current_user : FakeUser.find(params[:fake_user_id])
  end

  def address_params
    params.require(:address).permit(:street, :flat_number, :district, :area,
                                    :detail, :city, :latitude, :longitude)
  end
end
