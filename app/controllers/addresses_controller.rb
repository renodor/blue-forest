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
        # if from_dashboard params is present it means the user is trying to create its address from its dashboard
        # in that case we need to redirect him to his dashbaord after create
        if params[:from_dashboard]
          redirect_to dashboards_path
        else
          redirect_to new_user_order_path(@user)
        end
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
    # if user wants to modify its address, there are 3 conditions possibles:
    # 1. It is a registered user, who wants to modify its address while ordering
    # 2. It is a registered user, who wants to modify its address from its dashboard
    # 3. It is a non-registered user (fake user), who wants to modify its address while ordering
    if user_signed_in?
      # if params[order_edit] is present, it means user is trying to modify its address while ordering
      params['order_edit'] ? update_order_edit_user_address : update_user_address
    else
      update_order_edit_fake_user_address
    end
  end

  # Option1. It is a registered user, who wants to modify its address while ordering
  def update_order_edit_user_address
    @address = Address.find(params[:id])
    @user = current_user
    @address.user = @user
    if @address.update(address_params)
       redirect_to new_user_order_path(@user)
    else
      render :edit
    end
  end

  # Option2. It is a registered user, who wants to modify its address from its dashboard
  def update_user_address
    @address = Address.find(params[:id])
    @user = current_user
    @address.user = @user
    if @address.update(address_params)
       redirect_to dashboards_path
    else
      render :edit
    end
  end

  # Option3. It is a non-registered user (fake user), who wants to modify its address while ordering
  def update_order_edit_fake_user_address
    @address = Address.find(params[:id])
    @fake_user = FakeUser.find(params[:fake_user_id])
    @address.fake_user = @fake_user
    if @address.update(address_params)
       redirect_to new_fake_user_order_path(@fake_user)
    else
      render :edit
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :flat_number, :district, :area, :detail, :city, :latitude, :longitude)
  end
end
